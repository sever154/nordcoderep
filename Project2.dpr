program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Character,
  System.Generics.Collections,
  System.SysUtils;

var
  DParams : TDictionary<string, string>;

procedure Init();
begin
  DParams := TDictionary<string, string>.Create();
  DParams.Add('хелп', 'введён параметр хелп');
  DParams.Add('север', 'введён параметр север');
end;

procedure &Final();
begin
  FreeAndNil(DParams);
end;

function GetInfo(const ParamName: string; out Info: string): Boolean;
begin
  Result := DParams.ContainsKey(ParamName);
  if Result then
    Info := DParams[ParamName];
end;

procedure Main();
var
  I       : Integer;
  ICount  : Integer;
  SParam  : string;
  CFirst  : PChar;
  SInfo   : string;
begin
  ICount := ParamCount;
  if ICount > 0 then
    begin
      for I := 1 to ICount do
      begin
        SParam := ParamStr(I).ToLower;
        if not SParam.IsEmpty then
          begin
            CFirst := @SParam[1];
            if CFirst^.IsInArray(['-']) then
              begin
                Inc(CFirst);
                if GetInfo(string(CFirst), SInfo) then
                  Writeln(SInfo)
                else
                  Writeln(string(CFirst) + ' параметр не найден');
              end
            else
              Writeln('параметр должен начинаться с -');
          end
        else
          Writeln('параметр пуст - втф?');
      end;
    end
  else
    Writeln('запуск без параметров');
end;

begin
  Init();
  try
    try
      Main();
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    &Final;
  end;

  Readln;
end.
