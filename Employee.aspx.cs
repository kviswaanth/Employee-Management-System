using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Configuration;
using System.Net.NetworkInformation;

namespace Bookxpert_Project
{
	public partial class Employee : System.Web.UI.Page
	{
        private readonly string connString = ConfigurationManager.ConnectionStrings["Constr"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
		{
            if (!IsPostBack)
                LoadEmployees();
        }
        private void LoadEmployees()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetEmployees", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvEmployees.DataSource = dt;
                    gvEmployees.DataBind();
                }
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("sp_SaveEmployee", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        // Check if Employee is being Updated or Inserted
                        int empId = string.IsNullOrEmpty(hdnEmployeeId.Value) ? 0 : Convert.ToInt32(hdnEmployeeId.Value);
                        cmd.Parameters.AddWithValue("@Id", empId > 0 ? (object)empId : DBNull.Value);
                        cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Designation", txtDesignation.Text.Trim());

                        // Parse DateOfJoin
                        DateTime doj;
                        if (DateTime.TryParseExact(txtDOJ.Text.Trim(), "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out doj))
                        {
                            cmd.Parameters.AddWithValue("@DateOfJoin", doj);
                        }
                        else
                        {
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                            lblMessage.Text = "Invalid Date Format! Please use dd/MM/yyyy.";
                            return;
                        }

                        cmd.Parameters.AddWithValue("@Salary", Convert.ToDecimal(txtSalary.Text.Trim()));
                        cmd.Parameters.AddWithValue("@Gender", rblGender.SelectedValue);
                        cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue);

                        cmd.ExecuteNonQuery();

                        // Success Message
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = empId > 0 ? "Employee updated successfully!" : "Employee added successfully!";

                        // Clear Fields & Reset Hidden Field
                        ClearFields();
                        hdnEmployeeId.Value = "";
                    }
                }

                // Refresh GridView
                LoadEmployees();
            }
            catch (FormatException ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Error: Invalid input format. " + ex.Message;
            }

        }

        protected void gvEmployees_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // Check if DataKeys are set and retrieve Employee ID
                if (gvEmployees.DataKeys[e.RowIndex] != null)
                {
                    int employeeId = Convert.ToInt32(gvEmployees.DataKeys[e.RowIndex].Value);

                    // Call Delete function
                    DeleteEmployee(employeeId);

                    // Reload GridView
                    LoadEmployees();
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    // Show success message (Optional)
                    lblMessage.Text = "Employee deleted successfully!";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
            }

        }
        private void DeleteEmployee(int employeeId)
        {

            using (SqlConnection con = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_DeleteEmployee", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", employeeId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void ClearFields()
        {
            txtName.Text = "";
            txtDesignation.Text = "";
            txtDOJ.Text = "";
            txtSalary.Text = "";
            rblGender.ClearSelection();
            ddlState.SelectedIndex = 0;
        }

        protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRecord")
            {
                int empId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT * FROM Employees WHERE Id = @Id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Id", empId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hdnEmployeeId.Value = reader["Id"].ToString();
                                txtName.Text = reader["Name"].ToString();
                                txtDesignation.Text = reader["Designation"].ToString();
                                txtDOJ.Text = Convert.ToDateTime(reader["DateOfJoin"]).ToString("dd/MM/yyyy");
                                txtSalary.Text = reader["Salary"].ToString();
                                rblGender.SelectedValue = reader["Gender"].ToString();
                                ddlState.SelectedValue = reader["State"].ToString();
                            }
                        }
                    }
                }
            }

        }
        private DataTable GetEmployeeById(int id)
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT Id, Name, Designation, DateOfJoin, Salary, Gender, State FROM Employees WHERE Id = @Id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        conn.Open();
                        da.Fill(dt);
                    }
                }
            }

            return dt; // Now it will return actual data from DB
        }

        protected void Btn_Click(object sender, EventArgs e)
        {
            ClearFields();
        }
    }
}