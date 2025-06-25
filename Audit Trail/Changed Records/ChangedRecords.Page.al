page 92751 "PTE Changed Records"
{
    Caption = 'Audit Trail - Changed Records';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = AllObj;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(Filter)
            {
                ShowCaption = false;
                field(FromDateTime; FromDateTime)
                {
                    trigger OnValidate()
                    begin
                        CalculateChangedRecords();
                    end;
                }
                field(SetFromId; FromId)
                {
                    trigger OnValidate()
                    begin
                        CalculateChangedRecords();
                    end;
                }
                field(SetToId; ToId)
                {
                    trigger OnValidate()
                    begin
                        CalculateChangedRecords();
                    end;
                }

            }
            repeater(GroupName)
            {
                field(ID; Rec."Object ID")
                {

                }
                field(ObjectName; Rec."Object Name")
                {
                }
                field(NoOfRecordsCreated; GetRecordCreatedCounter())
                {
                    trigger OnDrillDown()
                    var
                        GenericRecord: Variant;
                        RecRef: RecordRef;
                    begin
                        RecRef.Open(Rec."Object ID");
                        RecRef.Field(2000000001).SetRange(FromDateTime, CurrentDateTime);
                        GenericRecord := RecRef;
                        Page.Run(0, GenericRecord);
                    end;

                }
                field(NoOfRecordsModified; GetRecordModifiedCounter())
                {
                    trigger OnDrillDown()
                    var
                        GenericRecord: Variant;
                        RecRef: RecordRef;
                    begin
                        RecRef.Open(Rec."Object ID");
                        RecRef.Field(2000000003).SetRange(FromDateTime, CurrentDateTime);
                        GenericRecord := RecRef;
                        Page.Run(0, GenericRecord);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
    local procedure CalculateChangedRecords()
    var
        AllObj: Record AllObj;
        RecordCounter: List of [Integer];
        Dlg: Dialog;
    begin
        Rec.DeleteAll();
        Clear(RecordCounters);
        Dlg.Open('Scanning database for changes #1#############');
        AllObj.SetRange("Object Type", Rec."Object Type"::Table);
        AllObj.SetRange("Object ID", FromId, ToId);
        AllObj.FindSet();
        repeat
            Dlg.Update(1, AllObj."Object ID");
            Clear(RecordCounter);
            Rec := AllObj;
            Rec.Insert();
            RecordCounter.Add(RecordsCreated(Rec."Object ID"));
            RecordCounter.Add(RecordsModified(Rec."Object ID"));
            RecordCounters.Add(Rec."Object ID", RecordCounter);
        until AllObj.Next() = 0;
        Dlg.Close();
    end;

    local procedure GetRecordCreatedCounter(): Integer
    begin
        if Rec."Object ID" <> 0 then
            exit(RecordCounters.Get(Rec."Object ID").Get(1));
    end;

    local procedure GetRecordModifiedCounter(): Integer
    begin
        if Rec."Object ID" <> 0 then
            exit(RecordCounters.Get(Rec."Object ID").Get(2));
    end;

    local procedure RecordsCreated(ObjId: Integer): Integer
    var
        RecRef: RecordRef;
    begin
        if ObjId = 0 then
            exit;
        RecRef.Open(ObjId);
        RecRef.Field(2000000001).SetRange(FromDateTime, CurrentDateTime);
        exit(RecRef.Count);
    end;

    local procedure RecordsModified(ObjId: Integer): Integer
    var
        RecRef: RecordRef;
    begin
        if ObjId = 0 then
            exit;
        RecRef.Open(ObjId);
        RecRef.Field(2000000003).SetRange(FromDateTime, CurrentDateTime);
        exit(RecRef.Count);
    end;

    trigger OnOpenPage()
    begin
        FromId := 3;
        ToId := 99;
    end;

    var
        RecordCounters: Dictionary of [Integer, List of [Integer]];
        FromId, ToId : integer;
        FromDateTime: DateTime;
}