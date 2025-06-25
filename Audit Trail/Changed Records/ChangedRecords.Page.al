page 92751 "PTE Changed Records"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
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
            }
            repeater(GroupName)
            {
                field(ID; Rec."Object ID")
                {

                }
                field(ObjectName; Rec."Object Name")
                {
                }
                field(NoOfRecordsCreated; GetRecordCreatedCounter()) { }
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
    begin
        Rec.DeleteAll();
        AllObj.SetRange("Object Type", Rec."Object Type"::Table);
        AllObj.FindSet();
        repeat
            Rec := AllObj;
            Rec.Insert();
        until AllObj.Next() = 0;
    end;

    local procedure GetRecordCreatedCounter(): Integer
    begin
        exit(RecordCounters.Get(Rec."Object ID").Get(1));
    end;

    local procedure GetRecordModifiedCounter(): Integer
    begin
        exit(RecordCounters.Get(Rec."Object ID").Get(2));
    end;

    local procedure RecordsCreated(): Integer
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(Rec."Object ID");
        RecRef.Field(2000000001).SetRange(FromDateTime, CurrentDateTime);
        exit(RecRef.Count);
    end;

    var
        RecordCounters: Dictionary of [Integer, List of [Integer]];
        FromDateTime: DateTime;
}