VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmFind 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Find Functions"
   ClientHeight    =   2760
   ClientLeft      =   45
   ClientTop       =   615
   ClientWidth     =   6870
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2760
   ScaleWidth      =   6870
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdSearch 
      Caption         =   "Search"
      Height          =   315
      Left            =   5700
      TabIndex        =   3
      Top             =   2400
      Width           =   1155
   End
   Begin VB.CheckBox chkUnmatchedOnly 
      Caption         =   "Show only unmatched"
      Height          =   255
      Left            =   3660
      TabIndex        =   2
      Top             =   2400
      Width           =   1875
   End
   Begin VB.TextBox txtFind 
      Height          =   285
      Left            =   1020
      TabIndex        =   1
      Top             =   2400
      Width           =   2535
   End
   Begin MSComctlLib.ListView lv1 
      Height          =   2355
      Left            =   0
      TabIndex        =   4
      Top             =   0
      Width           =   3375
      _ExtentX        =   5953
      _ExtentY        =   4154
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   2
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "name"
         Object.Width           =   3881
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "length"
         Object.Width           =   2540
      EndProperty
   End
   Begin MSComctlLib.ListView lv2 
      Height          =   2355
      Left            =   3480
      TabIndex        =   5
      Top             =   0
      Width           =   3315
      _ExtentX        =   5847
      _ExtentY        =   4154
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   2
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "name"
         Object.Width           =   3881
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "length"
         Object.Width           =   2540
      EndProperty
   End
   Begin VB.Label Label1 
      Caption         =   "Search For"
      Height          =   255
      Left            =   60
      TabIndex        =   0
      Top             =   2460
      Width           =   915
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "mnuPopup"
      Begin VB.Menu mnuCopy 
         Caption         =   "Copy"
      End
      Begin VB.Menu mnuCopyAll 
         Caption         =   "Copy All"
      End
   End
End
Attribute VB_Name = "frmFind"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'Author: david@idefense.com <david@idefense.com, dzzie@yahoo.com>
'
'License: Copyright (C) 2005 iDefense.com, A Verisign Company
'
'         This program is free software; you can redistribute it and/or modify it
'         under the terms of the GNU General Public License as published by the Free
'         Software Foundation; either version 2 of the License, or (at your option)
'         any later version.
'
'         This program is distributed in the hope that it will be useful, but WITHOUT
'         ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
'         FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
'         more details.
'
'         You should have received a copy of the GNU General Public License along with
'         this program; if not, write to the Free Software Foundation, Inc., 59 Temple
'         Place, Suite 330, Boston, MA 02111-1307 USA

Dim selLV As ListView

Private Sub cmdSearch_Click()

    Dim rs As Recordset
    Dim li As ListItem
    Dim sql As String
    Dim tblA, tblB
    
    If Form1.SigMode Then
        tblA = "tmp"
        tblB = "signatures"
    Else
        tblA = "a"
        tblB = "b"
    End If
    
    txtFind = Replace(txtFind, "'", Empty)
    sql = "Select * from " & tblA & " where disasm like '%" & txtFind & "%'"
    
    lv1.ListItems.Clear
    lv2.ListItems.Clear
    
    Set rs = Form1.cn.Execute(sql)
    While Not rs.EOF
        If isUnmatched(rs!autoid, True) Then
            Set li = lv1.ListItems.Add(, "id:" & rs!autoid, rs!fname)
            li.Tag = rs!autoid
            li.SubItems(1) = rs!leng
        End If
        rs.MoveNext
    Wend
    
    sql = "Select * from " & tblB & " where disasm like '%" & txtFind & "%'"
    Set rs = Form1.cn.Execute(sql)
    While Not rs.EOF
        If isUnmatched(rs!autoid, False) Then
            Set li = lv2.ListItems.Add(, "id:" & rs!autoid, rs!fname)
            li.Tag = rs!autoid
            li.SubItems(1) = rs!leng
        End If
        rs.MoveNext
    Wend
    

End Sub

Private Function isUnmatched(autoid, isTableA As Boolean) As Boolean
    
    Dim lv As ListView
    Dim li As ListItem
    On Error Resume Next
    
    If chkUnmatchedOnly.value = 0 Then
        isUnmatched = True
        Exit Function
    End If

    Set lv = IIf(isTableA, Form1.lv1, Form1.lv2)
    Set li = lv.ListItems("id:" & autoid)
    If Not li Is Nothing Then isUnmatched = True
    
End Function
 
Private Sub Form_Load()
    On Error Resume Next
    Me.Icon = Form1.Icon
    mnuPopup.Visible = False
    With lv1.ColumnHeaders(2)
        .Width = lv1.Width - .left - 100
    End With
    With lv2.ColumnHeaders(2)
        .Width = lv2.Width - .left - 100
    End With
End Sub


Private Sub lv1_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    
    Dim id As Long
    Dim asm As String
    Dim li As ListItem
    
    Set li = Form1.lv1.ListItems(Item.key) 'works for unmatched only
    
    If Not li Is Nothing Then
        Form1.lv1_ItemClick li
    Else
        'its a matched function
        id = Form1.FindMatchAutoID(Item.Text, True)
        If id <> 0 Then
            asm = ado("Select disasm from a where autoid=" & id)!disasm
            rtfHighlightAsm asm, Nothing, Form1.txtA
        End If
    End If
    
End Sub

   
Private Sub lv2_ItemClick(ByVal Item As MSComctlLib.ListItem)
    On Error Resume Next
    
    Dim id As Long
    Dim asm As String
    Dim li As ListItem
    
    Set li = Form1.lv2.ListItems(Item.key) 'works for unmatched only
    
    If Not li Is Nothing Then
        Form1.lv2_ItemClick li
    Else
        'its a matched function
        id = Form1.FindMatchAutoID(Item.Text, False)
        If id <> 0 Then
            asm = ado("Select disasm from b where autoid=" & id)!disasm
            rtfHighlightAsm asm, Nothing, Form1.txtB
        End If
    End If
    
End Sub


Private Sub lv1_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    Set selLV = lv1
    If Button = 2 Then PopupMenu mnuPopup
End Sub

Private Sub lv2_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    Set selLV = lv2
    If Button = 2 Then PopupMenu mnuPopup
End Sub

Private Sub mnuCopy_Click()
    On Error Resume Next
    If selLV Is Nothing Then Exit Sub
    Clipboard.Clear
    Clipboard.SetText selLV.SelectedItem.Text
End Sub

Private Sub mnuCopyAll_Click()

    On Error Resume Next
    If selLV Is Nothing Then Exit Sub
    
    Dim tmp As String
    Dim li As ListItem
    
    For Each li In selLV.ListItems
        tmp = tmp & li.Text & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText tmp
    
End Sub











