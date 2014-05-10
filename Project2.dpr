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
end;

procedure &Final();
begin
  FreeAndNil(DParams);
end;

function AddParam(const Param: string): Boolean;
var
  SplitParam : TArray<string>;
begin
  SplitParam := Param.Split(['=']);
  Result := Length(SplitParam) > 1;
  if Result then
    with DParams do
    begin
      if not ContainsKey(SplitParam[0]) then
        Add(SplitParam[0], SplitParam[1]);
    end;
end;

procedure ParseParams();
var
  I       : Integer;
  ICount  : Integer;
  SParam  : string;
  CFirst  : PChar;
begin
  ICount := ParamCount;
  if ICount > 0 then
    begin
      for I := 1 to ICount do
      begin
        SParam := ParamStr(I).ToLower();
        if not SParam.IsEmpty() then
          begin
            CFirst := @SParam[1];
            if CFirst^.IsInArray(['-']) then
              begin
                Inc(CFirst);
                AddParam(string(CFirst));
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

procedure WriteParams();
var
  Item  : TPair<string, string>;
begin
  if DParams.Count > 0 then
    for Item in DParams do
      Writeln(Item.Key + ' = ' + Item.Value)
  else
    Writeln('параметров нет');
end;

begin
  Init();
  try
    try
      ParseParams();
      Writeln(StringOfChar('=', 79));
      WriteParams();
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    &Final;
  end;

  Readln;
end.
