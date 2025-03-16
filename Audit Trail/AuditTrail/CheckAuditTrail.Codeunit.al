codeunit 92682 "PTE Audit Trail"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", OnInsertLogEntryOnBeforeChangeLogEntryValidateChangedRecordSystemId, '', false, false)]
    local procedure TestAuditTrailPresent(var ChangeLogEntry: Record "Change Log Entry"; FldRef: FieldRef; RecRef: RecordRef)
    var
        AuditTrail: Record "PTE Audit Trail Entry";
    begin
        if RecRef.Number = Database::"Change Log Setup (Table)" then // Do not audit the change log itsself
            exit;

        if RecRef.Number = Database::"Change Log Setup (Field)" then // Do not audit the change log itsself
            exit;

        AuditTrail.SetRange("Table ID", RecRef.Number);
        AuditTrail.SetRange("Field ID", FldRef.Number);
        if AuditTrail.IsEmpty then
            Error('There is no Audit Trail for this change. Please request permission first.');
    end;
}