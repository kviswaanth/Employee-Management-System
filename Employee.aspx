<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Employee.aspx.cs" Inherits="Bookxpert_Project.Employee" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.5/jquery.validate.min.js"></script>

    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
            height: 237px;
        }
        .auto-style2 {
            width: 246px;
        } 
        .error {
        color: red;
        font-size: 14px;
        font-weight: bold;
    }
    </style>
     <script>
         $(document).ready(function () {
             var total = 0;

             // Loop through each salary cell inside the GridView
             $(".salary").each(function () {
                 total += parseFloat($(this).text()) || 0;
             });

             // Update the ASP.NET Label with Total Salary
             $("#<%= lblTotalSalary.ClientID %>").text(total.toFixed(2));
        });
    </script>
</head>
<body>
<script>
    $(document).ready(function () {
        $("#form1").validate({
            rules: {
                txtName: {
                    required: true,
                    minlength: 3
                },
                txtDesignation: {
                    required: true
                },
                txtSalary: {
                    required: true,
                    number: true
                },
                rblGender: {
                    required: true
                },
                ddlState: {
                    required: true
                }
            },
            messages: {
                txtName: {
                    required: "Please enter your name",
                    minlength: "Name must be at least 3 characters long"
                },
                txtDesignation: {
                    required: "Please enter designation"
                },
                txtSalary: {
                    required: "Please enter salary",
                    number: "Only numbers are allowed"
                },
                rblGender: {
                    required: "Please select gender"
                },
                ddlState: {
                    required: "Please select a state"
                }
            },
            errorPlacement: function (error, element) {
                if (element.attr("type") === "radio") {
                    error.insertAfter(element.closest("table"));
                } else {
                    error.insertAfter(element);
                }
            }
        });

        // Custom validation for DropDownList
        $.validator.addMethod("valueNotEmpty", function (value, element) {
            return value !== "";  // Ensures a state is selected
        }, "Please select a state");

        $("#ddlState").rules("add", { valueNotEmpty: true });
    });
</script>


    <form id="form1" runat="server">
        <div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Employee Details</div>
    
    <table class="auto-style1">
        <tr>
            <td class="auto-style2">&nbsp;Name&nbsp;</td>
            <td><asp:TextBox ID="txtName" runat="server" ClientIDMode="Static"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="auto-style2">Designation</td>
            <td><asp:TextBox ID="txtDesignation" runat="server" ClientIDMode="Static"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="auto-style2">Date of Join </td>
            <td><asp:TextBox ID="txtDOJ" runat="server" ClientIDMode="Static"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="auto-style2">Salary</td>
            <td><asp:TextBox ID="txtSalary" runat="server" ClientIDMode="Static"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="auto-style2">Gender</td>
            <td><asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
        <asp:ListItem Text="Male" Value="M"></asp:ListItem>
        <asp:ListItem Text="Female" Value="F"></asp:ListItem>
    </asp:RadioButtonList></td>
        </tr>
        <tr>
            <td class="auto-style2">State</td>
            <td> <asp:DropDownList ID="ddlState" runat="server" ClientIDMode="Static">
        <asp:ListItem Text="-SelectState-" Value=""></asp:ListItem>
        <asp:ListItem Text="Andhra Pradesh" Value="Andhra Pradesh"></asp:ListItem>
        <asp:ListItem Text="Karnataka" Value="Karnataka"></asp:ListItem>
        <asp:ListItem Text="Tamil Nadu" Value="Tamil Nadu"></asp:ListItem>
    </asp:DropDownList></td>
        </tr>
    </table>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
      <asp:Button ID="btnSave" runat="server" Text="SAVE" OnClick="btnSave_Click" />

        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Btn" runat="server" Text="Clear" OnClick="Btn_Click"  />
        <br />
        <asp:Label ID="lblMessage" runat="server"></asp:Label>
        <br />
        <br />
        <asp:HiddenField ID="hdnEmployeeId" runat="server" />

    <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" 
    PageSize="2" 
    AutoGenerateDeleteButton="True" OnRowDeleting="gvEmployees_RowDeleting" OnRowCommand="gvEmployees_RowCommand">
    <Columns>
        <asp:TemplateField HeaderText="Name">
            <ItemTemplate>
                <asp:LinkButton ID="lnkEdit" runat="server" Text='<%# Eval("Name") %>' 
                    CommandName="EditRecord" CommandArgument='<%# Eval("Id") %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="Designation" HeaderText="Designation" />
        <asp:BoundField DataField="DateOfJoin" HeaderText="DOJ" DataFormatString="{0:dd/MM/yyyy}" />
        <asp:TemplateField HeaderText="Salary">
                    <ItemTemplate>
                        <span class="salary"><%# Eval("Salary") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
        <asp:BoundField DataField="Gender" HeaderText="Gender" />
        <asp:BoundField DataField="State" HeaderText="State" />

    </Columns>
</asp:GridView>


                <h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Total Salary: <asp:Label ID="lblTotalSalary" runat="server" ForeColor="Red"></asp:Label></h3>

        </form>
</body>
</html>
