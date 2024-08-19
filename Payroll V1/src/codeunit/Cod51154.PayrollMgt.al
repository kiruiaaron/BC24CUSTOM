namespace PayrollV.PayrollV;
using System.Environment;

codeunit 51155 "Payroll Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnBeforeLogInEnd', '', false, false)]
    local procedure MyProcedure()
    begin
        // IF GUIALLOWED AND CheckLicencePermission(ObjectType2::Codeunit, CODEUNIT::"Payroll Posting") THEN
        PayrollCodeTransferred.gsSetActivePayroll;

    end;

    var
        PayrollCodeTransferred: Codeunit "Table Code Transferred-Payroll";
}
