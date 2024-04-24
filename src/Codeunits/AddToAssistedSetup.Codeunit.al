// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - AddToAssistedSetup codeunit created 

codeunit 50140 AddToAssistedSetup
{
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, true)]
    local procedure OnSeminarSetup()
    var
        AssistedSetup: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
    begin
        if not AssistedSetup.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::"Seminar Assisted Setup Page") then
            AssistedSetup.InsertAssistedSetup('Setup Seminar', 'Update Seminar application area', 'Seminar application area setup.', 1, ObjectType::Page, Page::"Seminar Assisted Setup Page", AssistedSetupGroup::"Seminar Management", '', VideoCategory::Uncategorized, '');
    end;

}

