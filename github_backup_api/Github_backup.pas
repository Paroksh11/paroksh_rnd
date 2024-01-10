unit Github_backup;

interface
uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
    IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,IdSSLOpenSSL,IdAuthentication,
    Soap.EncdDecd,IdCoder, IdCoder3to4, IdCoderMIME,IdMultipartFormData,StrUtils,
    System.IOUtils;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Memo1: TMemo;
    Pushl_backup: TButton;
    FileOpenDialog1: TFileOpenDialog;
    Memo4: TMemo;
    Open: TButton;
    Pull: TButton;
    Edit1: TEdit;
    FileName: TLabel;
    OpenDialog1: TOpenDialog;
    Memo5: TMemo;
    location: TButton;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure Pushl_backupClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure PullClick(Sender: TObject);
    procedure locationClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sha:string;
  jsonstr:string;
  content:string;
  JsonToSend: TStringStream;
  FilePath:String;
  byte64 :string;
  bl:bool;
  tt,dd,ddt,ttt:string;

function takebackup(fname:string;memo1:TMemo;memo4:TMemo;CheckBox1:TCheckBox):String;      //for backup
function FileToByteArray(const Input: string;CheckBox1:TCheckBox): string;     //to convert file data into base64
function pullfile(filename:string;memo1:TMemo;mem:string;CheckBox1:TCheckBox):String;     //for pull
function ByteArrayToString(const Input: String;CheckBox1:TCheckBox): string;   //for convert base64 to file
function createlog(const Input: string;bl:bool):String; //for log record


implementation

{$R *.dfm}

////////////////////////////////////////////////////////////////////////////////////////////
function createlog(const Input: string;bl:bool):String;
var
  myfile:TextFile;
  path:string;
  filename:string;
  p,pp:string;

begin
  pp:=TimeToStr(time());
  p:=StringReplace(pp,':','',[rfReplaceAll,rfIgnoreCase]);
  path:='Log\';
  filename:=tt+dd+'log.txt';
  //ShowMessage(path+filename);
  AssignFile(myfile,path+filename);
  if FileExists(path+filename) then
  Append(myfile)
  else
  Rewrite(myfile);
  //ShowMessage('fileassigned');                            //writing in file
  Writeln(myfile,p+' '+Input);
  CloseFile(myfile);
end;
////////////////////////////////////////////////////////////////////////////////////////////
function pullfile(filename:string;memo1:TMemo;mem:String;CheckBox1:TCheckBox):String;
var
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  IdHTTP1: TIdHTTP;
  Token: string;
  Owner: string;
  Name: string;
  filName,FileN: string;
  GitHubAPIURL: string;
  FileContent:string;
  myfile:TextFile;
  content:string;
  decodedstring:string;
begin
    if CheckBox1.Checked then
    createlog('File pulling operation start',bl);
  IdHTTP1:=TIdHTTP.Create;
    if CheckBox1.Checked then
    createlog('Http object created',bl);
  SSLIOHandler:=TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP1);
  SSLIOHandler.SSLOptions.Method:=sslvTLSv1_2;
  IdHTTP1.IOHandler:=SSLIOHandler;
  Token := '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';    //github token
  Owner := 'Paroksh11';                                   //repository owner
  Name := 'apitrial';                                     //repository name
  filName :=filename;                                 //filename
  FileN:=Concat(trim(mem),'\',filName);
  ShowMessage(FileN);
  GitHubAPIURL := Format('https://api.github.com/repos/%s/%s/contents/%s',[Owner,Name,filName]);
    if CheckBox1.Checked then
    createlog('GitHuburl created according to credentials',bl);
  IdHTTP1.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Token);
    if CheckBox1.Checked then
    createlog('Headers added to the body',bl);
  try
    begin
      Memo1.lines.add(GitHubAPIURL);
      FileContent := IdHTTP1.Get(GitHubAPIURL);  //get request we get from url
        if CheckBox1.Checked then
        createlog('Get requested sent to server',bl);
      Memo1.Lines.add(Filecontent);
      content:=copy(FileContent,pos('"content":"',FileContent)+11,(pos('"encoding":',FileContent)-15-pos('"content":"',FileContent)));
        if CheckBox1.Checked then
        createlog('Content part taken from body',bl);
      ShowMessage(content);
     decodedstring:=ByteArrayToString(content,CheckBox1);     //decoding base64
        if CheckBox1.Checked then
        createlog('Got decoded base64 string to normal string',bl);
     ShowMessage(decodedstring);
     AssignFile(myfile,FileN);                      //decoded string to file
     Rewrite(myfile);                               //writing in file
     Writeln(myfile,decodedstring);
        if CheckBox1.Checked then
        createlog('assign decoded string to specific file on desired location',bl);
     CloseFile(myfile);
     ShowMessage('File get pulled');
     end
  except on E:Exception do                          //error
  ShowMessage(E.Message);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////

function ByteArrayToString(const Input: String;CheckBox1:TCheckBox): string;
var
  Decoder: TIdDecoderMIME;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    Result := Decoder.DecodeString(Input);       //decoded string
  finally
    Decoder.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////

function FileToByteArray(const Input: String;CheckBox1:TCheckBox): string;
var
    stream:TMemoryStream;
    A:string;
begin
  try
    begin
      stream:=TMemoryStream.Create;
      stream.LoadFromFile(Input);
      stream.Position:=0;
      A:=EncodeBase64(stream.Memory,stream.Size);         //encoded string
      A:=StringReplace(A,slinebreak,'',[rfReplaceAll,rfIgnoreCase]) ;
      Result:=A;
      stream.Free;
    end;
  except on e:Exception do
    begin
      if CheckBox1.Checked then
      createlog(e.Message,bl);
    end;
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////////

function takebackup(fname:String;memo1:TMemo;memo4:TMemo;CheckBox1:TCheckBox):String;   //for backup and push
var
  GitHubAPIURL,GitHubAPIURLB: string;
  {GitHubAPIURL if file is not exits and GitHubAPIURLB if file exists already}
  Token: string;
  Owner: string;
  Name: string;
  FileName: string;
  FileContent: string;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  IdHTTP1: TIdHTTP;
  location:string;
  sourcepath:String;
  destinationpath:String;
  d,ds:string;
  t,ts:string;

begin
  if CheckBox1.Checked then
        createlog('File push operation started',bl);
  IdHTTP1:=TIdHTTP.Create;
   if CheckBox1.Checked then
    createlog('Http object created',bl);
  SSLIOHandler:=TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP1);
  SSLIOHandler.SSLOptions.Method:=sslvTLSv1_2;
  IdHTTP1.IOHandler:=SSLIOHandler;
  Token := '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';    //github token
  Owner := 'Paroksh11';                                   //repository owner
  Name := 'apitrial';                                     //repository name
  FileName := fname;                             //filename whose data we want
  d:=DateToStr(Date());
  ds:=StringReplace(d,'/','',[rfReplaceAll, rfIgnoreCase]);
  t:=timeToStr(time());                                       //for timestamp
  ts:=StringReplace(t,':','',[rfReplaceAll, rfIgnoreCase]);
  GitHubAPIURL := Format('https://api.github.com/repos/%s/%s/contents/%s',[Owner,Name, FileName]);
  GitHubAPIURLB := Format('https://api.github.com/repos/%s/%s/contents/backup/%s', [Owner,Name, ts+ds+FileName]);
  if CheckBox1.Checked then
    createlog('GitHuburl created according to credentials',bl);
  IdHTTP1.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Token);
  if CheckBox1.Checked then
    createlog('Headers added to the body',bl);
  try
    begin
      FileContent := IdHTTP1.Get(GitHubAPIURL);  //get request we get from url
      if CheckBox1.Checked then
        createlog('Get requested sent to server',bl);
      Memo1.Clear;
      Memo1.Lines.add(Filecontent);
      content:=copy(FileContent,pos('"content":"',FileContent)+11,(pos('"encoding":',FileContent)-15-pos('"content":"',FileContent)));
      if CheckBox1.Checked then
        createlog('Content part taken from body',bl);
      sha:=copy(FileContent,pos('"sha":',FileContent)+6,(pos('"size":',FileContent)-7-pos('"sha":',FileContent)));
      if CheckBox1.Checked then
        createlog('sha part taken from body',bl);
      if length(sha)<>0 then    {If file already exists inside git repository}
        begin
          if CheckBox1.Checked then
            createlog('backup file of '+fname+'is going to create inside github and another updated file',bl);
           sourcepath:='https://github.com/Paroksh11/apitrial/tree/main/'+fname;
           destinationpath:='https://github.com/Paroksh11/apitrial/tree/main/backup/';
           jsonstr:='{"message": "Commit message","sha": '+sha+',"content": "'+content+'","branch": "main"}'; //jason string
           JsonToSend:=TStringStream.Create(Utf8Encode(jsonstr));
           IdHTTP1.put(GitHubAPIURLB,JsonToSend);
           if CheckBox1.Checked then
             createlog('Put requested sent to server',bl);
           if CheckBox1.Checked then
            createlog('backup file of '+fname+'is pushed to backup folder in github',bl);
           showmessage(fname+'pushed successfully');
        end;
    end;
  except on E: Exception do
  begin
    if ContainsText(E.Message,'404') then    {if file name isnot correct then we caan face 404 error}
      begin
        if CheckBox1.Checked then
            createlog(fname+'File is going to be push first time',bl);
        FilePath:=trim(Memo4.text);
        byte64:=FileToByteArray(FilePath,CheckBox1);
        if CheckBox1.Checked then
          createlog('Base64 coded for '+fname+'get in byte64 string',bl);
        jsonstr:='{"message":"Commit message","content":"'+byte64+'","branch":"main"}'; //jason string
        jsonstr:=WrapText(jsonstr);
        JsonToSend:=TStringStream.Create(Utf8Encode(jsonstr));
        IdHTTP1.put(GitHubAPIURL,JsonToSend);
        if CheckBox1.Checked then
          createlog(fname+' Put request sent to server',bl);
        ShowMessage(fname+'pushed first time successfully');
      end;
    end;
  end;
End;
////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.PullClick(Sender: TObject);       //to pull the data
var
    I:integer;
    SL:TStringList;
    line:string;
begin
    Memo1.Clear;
    pullfile(Edit1.text+'.txt',memo1,Memo5.Text,CheckBox1);
end;
////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.Pushl_backupClick(Sender: TObject);
var
    I:integer;
    SL:TStringList;
    line:string;
begin
    SL := TStringList.Create;
    SL.Text := Memo4.Text;
    for line in SL do
      if line<>'' then
        begin
          Memo1.Clear;
          showmessage(ExtractFileName(line));
          takebackup(ExtractFileName(line),memo1,memo4,CheckBox1);
        end;
end;
////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.OpenClick(Sender: TObject);         //to select file from local system
var
  OpenDialog: TFileOpenDialog;
  SelectedFolder: string;
  filestr:String;
begin
  OpenDialog := TFileOpenDialog.Create(nil);
    try
         OpenDialog.Options := OpenDialog.Options + [fdoAllowMultiSelect];
         if not OpenDialog.Execute then
         begin
         if CheckBox1.Checked then
          begin
            createlog('OpenDialog execution failed',bl);
          end;
            Abort;
         end;
          if CheckBox1.Checked then
          begin
            createlog('OpenDialog execution successfully working',bl);
          end;
            ShowMessage('Log working');
         filestr := OpenDialog.Files.Text;
    finally
         OpenDialog.Free;

    end;
     memo4.Clear;
     memo4.Lines.Add(filestr);
end;

//////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  bl:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ddt:=DateToStr(date());
  dd:=StringReplace(ddt,'/','',[rfReplaceAll,rfIgnoreCase]);
  ShowMessage(dd);
  ttt:=TimeToStr(time());
  tt:=StringReplace(ttt,':','',[rfReplaceAll,rfIgnoreCase]);
  ShowMessage(tt);
end;

procedure TForm1.locationClick(Sender: TObject);
var
  OpenDialog: TFileOpenDialog;
  Folderpath: string;
begin
  Memo5.Clear;
  OpenDialog := TFileOpenDialog.Create(nil);
  try
     OpenDialog.Options :=OpenDialog.Options +[fdoPickFolders];
     if not OpenDialog.Execute then
           Abort;
     Folderpath := OpenDialog.Files.Text;
     Memo5.Lines.Add(Folderpath);
  finally
    OpenDialog.Free;
  end;
end;
/////////////////////////////////////////////////////////////////////////////////////////
end.
