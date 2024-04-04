using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Employee.Models;
namespace Employee.DataAccessLayer
{
    public class EmployeeDal
    {
        string conString = ConfigurationManager.ConnectionStrings["SQlMvc"].ToString();

        public DataTable GetEmployeeDetails(int offset, int PageSize, string SearchKeyword)
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(conString))
            {
                SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "sp_Get_Employee_Details";
                command.Parameters.AddWithValue("@offset", offset);
                command.Parameters.AddWithValue("@PageSize", PageSize);
                command.Parameters.AddWithValue("@SearchKeyword", SearchKeyword);

                SqlDataAdapter sda = new SqlDataAdapter(command);

                connection.Open();
                sda.Fill(dt);
                connection.Close();
            }

            return dt;
        }
        public DataTable InsertUpdateEmployeeDetails(EmployeeModel employe)
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(conString))
            {
                SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "sp_InsertupdateEmployee";
                command.Parameters.AddWithValue("@ID",employe.ID);
                command.Parameters.AddWithValue("@Name",employe.Name);
                command.Parameters.AddWithValue("@Email",employe.Email);
                command.Parameters.AddWithValue("@DateOfBirth",employe.DateOfBirth);
                command.Parameters.AddWithValue("@Picture",employe.Picture);
                SqlDataAdapter sda = new SqlDataAdapter(command);

                connection.Open();
                sda.Fill(dt);
                connection.Close();
            }

            return dt;
        }
        public bool DeleteEmployee(int Id)
        {
            using (SqlConnection con=new SqlConnection(conString))
            {
                SqlCommand com = con.CreateCommand();
                com.CommandType = CommandType.StoredProcedure;
                com.CommandText = "sp_DeleteEmployee";                 //SqlCommand cmd = new SqlCommand("sp_DeleteEmployee", con);
                com.CommandType = CommandType.StoredProcedure;
                com.Parameters.AddWithValue("@ID", Id);
                con.Open();
                int i = com.ExecuteNonQuery();
                if (i >= 1)
                {
                    return true;
                    //con.Close();
                }
                else
                {
                    return false;
                }
            }
                
        }

    }
}