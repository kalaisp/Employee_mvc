using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Employee.Models
{
    public class EmployeeModel
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string DateOfBirth { get; set; }
        public string Email { get; set; }
        public string Picture { get; set; }
    }
}