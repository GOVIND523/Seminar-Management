pageextension 50106 "CSDDefaultDimMultiples" extends "Default Dimensions-Multiple"
{
    procedure SetMultiSeminar(var Seminar: Record Seminar)
    var
        TempDefaultDim2: Record "Default Dimension" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        TempDefaultDim2.DELETEALL();
        IF Seminar.FIND('-') THEN
            REPEAT
                CopyDefaultDimToDefaultDim(DATABASE::Seminar, Seminar."No.");
            UNTIL Seminar.NEXT() = 0;
    end;
}