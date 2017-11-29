program ProjectConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UnitTypeDefinition in 'UnitTypeDefinition.pas';

procedure foo;
var
  a: TGenericClassFromInterface<Integer, string>;
  a1: IGenericInterface<Integer, string>;
  b: TGenericClass<string>;
  c: TGenericClass<Integer>;
  d: TGenericClassDescendant<string>;
  e: TGenericClassDescendantInt;
begin
  a := TGenericClassFromInterface<Integer, string>.Create;
  a1 := a;

  b := TGenericClass<string>.Create;
  c := TGenericClass<Integer>.Create;
  d := TGenericClassDescendant<string>.Create;
  e := TGenericClassDescendantInt.Create;

  writeln('abc'); // set breakpoint here
end;

begin
  try
    foo;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
