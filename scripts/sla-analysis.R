

x <- readr::read_csv("data/forDB/sla-sample.csv", col_types = cols())

x$register_complaintdate <- as.POSIXct(x$register_complaintdate, format = '%d-%m-%Y %H:%M', tz = 'UTC')
x$comlaint_closedate <- as.POSIXct(x$comlaint_closedate, format = '%d-%m-%Y %H:%M', tz = 'UTC')
x$time_diff <- as.numeric(difftime(time1 = x$comlaint_closedate, time2 = x$register_complaintdate, units = "hours"))
x$sla_category <- ifelse(x$time_diff <=4, "under4H", ifelse(x$time_diff<=x$sla_time,"within_SLA","beyond_SLA"))
  
  
readr::write_csv(x, "data/forDB/sla-sample-format-dates.csv")

all_complaints_xl <-
  readxl::read_excel(path = "data/forDB/Full complain summary jun to nov -23.xlsx")
status_data <- all_complaints_xl[,c("Token_No","Status")]
names(status_data)[] <- c("token_no","status")
readr::write_csv(status_data, "data/forDB/complaint_status.csv")

employee_names <- all_complaints_xl[,c("Token_No","Allocation_Name")]
names(employee_names)[] <- c("token_no","employee_name")
readr::write_csv(employee_names, "data/forDB/employee_names.csv")



x <-
  readxl::read_excel(path = "data/forDB/Full complain summary jun to nov -23.xlsx",
                     col_types = c(
                       rep("text", 5),
                       "date",rep("text",5),
                       rep("skip", 2),
                       rep("text", 1),
                       "numeric",
                       rep("skip", 3),
                       "date"
                     ))
x$Register_ComplaintDate <- as.POSIXct(x$Register_ComplaintDate, format = '%d-%m-%Y %H:%M', tz = 'UTC')
x$Comlaint_CloseDate <- as.POSIXct(x$Comlaint_CloseDate, format = '%d-%m-%Y %H:%M', tz = 'UTC')
x$time_diff <- as.numeric(difftime(time1 = x$Comlaint_CloseDate, time2 = x$Register_ComplaintDate, units = "hours"))
x$sla_category <- ifelse(x$time_diff <=4, "less_than_4", ifelse(x$time_diff<=x$`SLA time`,"within_sla","beyond_sla"))
x$time_diff[is.na(x$time_diff)] <- -9999

names(x) <-
  c(
    "zone_name",
    "ward",
    "department_name",
    "complaint_no",
    "token_no",
    "register_complaintdate",
    "opearator",
    "mode",
    "allocation_name",
    "problem_name",
    "problem_category_name",
    "location_address",
    "sla_time",
    "complaint_closedate",
    "time_diff",
    "sla_category"
  )
readr::write_csv(x, "data/forDB/sla-results.csv")
