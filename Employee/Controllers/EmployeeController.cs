using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Employee.Models;
using Employee.DataAccessLayer;
using System.Data;
using System.IO;

namespace Employee.Controllers
{
    public class EmployeeController : Controller
    {
        // GET: Employee
        EmployeeDal emp = new EmployeeDal();
        public ActionResult Index()
        {
            
            return View();
        }
        [HttpGet]
        public JsonResult GetEmployee(int offset, int PageSize, string SearchKeyword)
        {
            try
            {
                DataTable dtEmployee = new DataTable();
                dtEmployee = emp.GetEmployeeDetails(offset, PageSize, SearchKeyword);
                List<EmployeeModel> lstEmployee = new List<EmployeeModel>();
                foreach (DataRow dr in dtEmployee.Rows)
                {
                    lstEmployee.Add(new EmployeeModel
                    {
                        ID = Convert.ToInt32(dr["ID"]),
                        Name = dr["Name"].ToString(),
                        Email = dr["Email"].ToString(),
                        DateOfBirth = dr["DateOfBirth"].ToString(),
                        Picture = dr["Picture"].ToString()
                    });

                }
                return Json(new { success = true, data = lstEmployee }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, data = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        [HttpPost]
        [AllowAnonymous]
        public JsonResult InsertUpdateEmployeeDetails(FormCollection form)
        {
            EmployeeModel employe = new EmployeeModel();
            employe = Newtonsoft.Json.JsonConvert.DeserializeObject<EmployeeModel>(form["EmpDet"]);
            HttpFileCollectionBase files = Request.Files;
            var pic = System.Web.HttpContext.Current.Request.Files[0];
            HttpPostedFileBase file = new HttpPostedFileWrapper(pic);
            employe.Picture = pic.FileName;
            string _FileName = employe.Picture;
            string _Ext = Path.GetExtension(file.FileName);
            var folder = Server.MapPath("~/UserImage");
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }
            string _path = Path.Combine(folder, _FileName);
            file.SaveAs(_path);
            try
            {
                //EmployeeModel employee
                
                DataTable dtSave = new DataTable();
                dtSave = emp.InsertUpdateEmployeeDetails(employe);
                List<EmployeeModel> lstEmployee = new List<EmployeeModel>();

                string message = dtSave.Rows[0]["MESSAGE"].ToString();
                int messageCode = Convert.ToInt16(dtSave.Rows[0]["MESSAGECODE"]);

                return Json(new { success = true, data = message, code = messageCode }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(ex.Message);
            }
        }
        [HttpPost]
        public ActionResult DeleteEmployee(int id)
        {
            //EmpoyeeRepository Emprep = new EmpoyeeRepository();
            return Json(emp.DeleteEmployee(id), JsonRequestBehavior.AllowGet);
        }
    }

    
}