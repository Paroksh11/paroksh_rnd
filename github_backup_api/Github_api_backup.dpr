program Github_api_backup;

uses
  Vcl.Forms,
  Github_backup in 'Github_backup.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
