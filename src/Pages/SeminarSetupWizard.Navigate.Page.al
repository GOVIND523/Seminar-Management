// SME1.00 - 2024-04-17 - Govind
//   Chapter 3 - Lab 2
//     - Seminar assisted setup wizard page created
Page 50140 "Seminar Assisted Setup Page"
{
    PageType = NavigatePage;
    SourceTable = "Seminar Setup";
    SourceTableTemporary = true;
    Caption = 'Setting Up Seminar';

    layout
    {
        area(Content)
        {
            group(FirstStep)
            {
                Visible = FirstStepVisible;
                group("Welcome")
                {
                    Caption = 'Welcome to the Seminar Management assisted setup';
                    group(Group1)
                    {
                        Caption = '';
                        InstructionalText = 'The primary objective of developing the , optimizing resource utilization, enhancing visibility and transparency, and simplifying invoicing and billing procedures. By leveraging the capabilities of Dynamics 365 Business Central.';
                    }
                }
                group("Let's go")
                {
                    Caption = 'Let''s go';
                    group(group12)
                    {
                        Caption = '';
                        InstructionalText = 'Select Next to get started.';
                    }
                }
            }
            group(SecondStep)
            {
                Caption = 'Enter the setup information.';
                Visible = SecondStepVisible;

                group(Group2)
                {
                    Caption = '';
                    InstructionalText = 'Fill in the following required setup information for Seminar Management';

                    group(Group3)
                    {
                        Caption = 'Defines the number series to be used to assign primary key to the Seminars.';
                        field("Seminar Nos."; Rec."Seminar Nos.")
                        {
                            Caption = 'Seminar Number Series';
                            ApplicationArea = All;
                            trigger OnLookup(var Text: Text): Boolean
                            var
                                NoSeriesRec: Record "No. Series";
                            begin
                                NoSeriesRec.Reset();
                                if Page.RunModal(Page::"No. Series", NoSeriesRec) = Action::LookupOK then
                                    Rec."Seminar Nos." := NoSeriesRec.Code;

                            end;
                        }
                    }
                    group(Group4)
                    {
                        Caption = 'Defines the number series to be used to assign primary key to the Seminar Registrations';
                        field("Seminar Registration Nos."; Rec."Seminar Registration Nos.")
                        {

                            Caption = 'Seminar Registration Number Series';
                            ApplicationArea = All;
                            trigger OnLookup(var Text: Text): Boolean
                            var
                                NoSeriesRec: Record "No. Series";
                            begin
                                NoSeriesRec.Reset();
                                if Page.RunModal(Page::"No. Series", NoSeriesRec) = Action::LookupOK then
                                    Rec."Seminar Registration Nos." := NoSeriesRec.Code;

                            end;
                        }

                    }
                    group(Group11)
                    {
                        Caption = 'Defines the number series to be used to assign primary key to the posted seminar registartions.';
                        field("Posted Seminar Reg. Nos."; Rec."Posted Seminar Reg. Nos.")
                        {

                            Caption = 'Posted Seminar Reg. Number Series';
                            ApplicationArea = All;
                            trigger OnLookup(var Text: Text): Boolean
                            var
                                NoSeriesRec: Record "No. Series";
                            begin
                                NoSeriesRec.Reset();
                                if Page.RunModal(Page::"No. Series", NoSeriesRec) = Action::LookupOK then
                                    Rec."Posted Seminar Reg. Nos." := NoSeriesRec.Code;

                            end;
                        }

                    }
                }
            }
            group(ThirdStep)
            {

                Visible = ThirdStepVisible;
                group(Group6)
                {
                    Caption = 'Finished Setting Up Seminars';
                    group(Group5)
                    {
                        Caption = '';
                        InstructionalText = 'You have successfully completed the setup of Seminar. You can now proceed with using the extension.';
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Back)
            {
                ApplicationArea = all;
                Caption = '&Back';
                Enabled = BackEnable;
                InFooterBar = true;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }

            action(Next)
            {
                ApplicationArea = all;
                Caption = '&Next';
                Enabled = NextEnable;
                InFooterBar = true;
                Image = NextRecord;
                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }

            action(Finish)
            {
                ApplicationArea = all;
                Caption = '&Finish';
                Enabled = FinishEnable;
                InFooterBar = true;
                Image = Approve;

                trigger OnAction()
                begin
                    Finished();
                end;
            }
        }
    }


    trigger OnInit()
    var

    begin

        EnableControls();

    end;

    trigger OnOpenPage()
    var
        GuidedExp: Codeunit "Guided Experience";
    begin

        if GuidedExp.IsAssistedSetupComplete(ObjectType::Page, Page::"Seminar Assisted Setup Page") then begin
            GuidedExp.ResetAssistedSetup(ObjectType::Page, Page::"Seminar Assisted Setup Page");
            CurrPage.Update();

        end;
        if SeminarSetup.Get then begin
            SeminarSetup.Init();
            Rec := SeminarSetup;
            CurrPage.Update();
        end;
    end;

    var
        FirstStepVisible: Boolean;
        SecondStepVisible: Boolean;
        ThirdStepVisible: Boolean;
        BackEnable: Boolean;
        NextEnable: Boolean;
        FinishActionEnable: Boolean;
        FinishEnable: Boolean;
        Stage: Option Start,Fill,Finish;
        SeminarSetup: Record "Seminar Setup";

    local procedure EnableControls()
    begin
        ResetControls();
        Case Stage of
            Stage::Start:
                ShowFirstStep();
            Stage::Fill:
                ShowSecondStep();
            Stage::Finish:
                ShowThirdStep();
        End;
    end;

    Local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Stage := Stage - 1
        else
            Stage := Stage + 1;
        EnableControls();
    end;

    local procedure ShowFirstStep()
    begin
        FirstStepVisible := true;
        BackEnable := false;
        NextEnable := true;
        FinishEnable := false;
    end;

    local procedure ShowSecondStep()
    begin
        SecondStepVisible := true;
        BackEnable := true;
        NextEnable := true;
        FinishEnable := false;
    end;

    local procedure ShowThirdStep()
    begin
        ThirdStepVisible := true;
        BackEnable := true;
        NextEnable := false;
        FinishEnable := true;
        FinishActionEnable := true;
    end;

    local procedure ResetControls()
    begin
        FinishEnable := False;
        BackEnable := false;
        NextEnable := true;
        FirstStepVisible := false;
        SecondStepVisible := false;
        ThirdStepVisible := false;
    end;

    local procedure Finished()
    var
        GuidedExp: Codeunit "Guided Experience";
    begin
        GuidedExp.CompleteAssistedSetup(ObjectType::Page, Page::"Seminar Assisted Setup Page");
        StoreRecordVar();
        CurrPage.Close();
    end;


    local procedure StoreRecordVar()
    begin
        if SeminarSetup.Get then
            SeminarSetup.DeleteAll();
        SeminarSetup.TransferFields(Rec, true);
        SeminarSetup.insert;
    end;


}