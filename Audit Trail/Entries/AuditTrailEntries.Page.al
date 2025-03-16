page 92750 "PTE Audit Trail Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PTE Audit Trail Entry";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Description; Rec.Description) { }
                field(TableID; Rec."Table ID") { }
                field(FieldID; Rec."Field ID") { }
            }
        }
    }

}