xmlport 50101 "Seminar Port"
{
    Format = VariableText;
    FormatEvaluate = Legacy;
    schema
    {
        textelement(Root)
        {
            tableelement(Seminar; Seminar)
            {
                XmlName = 'Seminar';
                fieldelement(name; Seminar.Name)
                { }
                fieldelement(MaxParticipant; Seminar."Maximum Participants")
                { }
                fieldelement(MinParticipants; Seminar."Minimum Participants")
                { }
                fieldelement(SeminarPrice; Seminar."Seminar Price")
                { }
            }
        }
    }
}