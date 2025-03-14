table 60000 "PTE Audit Trail Entry"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Editable = false;
        }
        field(10; Description; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(20; "Table ID"; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(30; "Field ID"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys { key(Key1; "Entry No.") { Clustered = true; } }

    trigger OnInsert()
    begin
        Message('Foo');
    end;

}