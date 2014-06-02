program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Rtti,
  TypInfo;

type
  TFoo = class
    // Frob doubles x and returns the new x + 10
    function Frob(var x: Integer): Integer; virtual;
  end;

function TFoo.Frob(var x: Integer): Integer;
begin
  x := x * 2;
  Result := x + 10;
end;

procedure WorkWithFoo(Foo: TFoo);
var
  a, b: Integer;
begin
  a := 10;
  Writeln('  [WorkWithFoo] before: a = ', a);
  try
    b := Foo.Frob(a);
    Writeln('  [WorkWithFoo] Result = ', b);
    Writeln('  [WorkWithFoo] after:  a = ', a);
  except
    on e: Exception do
      Writeln('  Exception: ', e.ClassName);
  end;
end;

procedure P;
var
  foo   : TFoo;
  a, b  : Integer;
  vmi   : TVirtualMethodInterceptor;
begin
  vmi := nil;
  foo := TFoo.Create;
  try
    Writeln('Before hackery:');
    a := 10;
    b := Foo.Frob(a);

    vmi := TVirtualMethodInterceptor.Create(foo.ClassType);

    vmi.OnBefore :=
      procedure(Instance: TObject; Method: TRttiMethod;
        const Args: TArray<TValue>; out DoInvoke: Boolean; out Result: TValue)
      var
        Arg : TValue;
        F   : function (var x: Integer): Integer of object;
        M   : TMethod absolute F;
      begin
        for Arg in Args do
        begin
          case Arg.Kind of
            tkInteger:
              begin
                Writeln('!!!' + IntToStr(Arg.AsInteger));
  //              Arg := Arg + 5;
              end;
          end;
        end;
        M.Data := self;
        M.Code := Method.CodeAddress;
        ;


        Result := 666;
      end;

    // Change foo's metaclass pointer to our new dynamically derived
    // and intercepted descendant
    vmi.Proxify(foo);

    Writeln('After interception:');
    WorkWithFoo(foo);
  finally
    foo.Free;
    vmi.Free;
  end;
end;

begin
  P;
  readln; // To see what's in console before it goes away.
end.
