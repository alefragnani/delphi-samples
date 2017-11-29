unit GenericVisualizer;

interface

procedure Register;

implementation

uses
  Classes, SysUtils, ToolsAPI;

type
  TGenericVisualizer = class(TInterfacedObject, IOTADebuggerVisualizer,
    IOTADebuggerVisualizer250, IOTADebuggerVisualizerValueReplacer,
    IOTAThreadNotifier, IOTAThreadNotifier160)
  private
    FCompleted: Boolean;
    FDeferredResult: string;
  public
    { IOTADebuggerVisualizer }
    function GetSupportedTypeCount: Integer;
    procedure GetSupportedType(Index: Integer; var TypeName: string;
      var AllDescendants: Boolean); overload;
    function GetVisualizerIdentifier: string;
    function GetVisualizerName: string;
    function GetVisualizerDescription: string;
    { IOTADebuggerVisualizer250 }
    procedure GetSupportedType(Index: Integer; var TypeName: string;
      var AllDescendants: Boolean; var IsGeneric: Boolean); overload;
    { IOTADebuggerVisualizerValueReplacer }
    function GetReplacementValue(const Expression, TypeName,
      EvalResult: string): string;
    { IOTAThreadNotifier }
    procedure EvaluteComplete(const ExprStr: string; const ResultStr: string;
      CanModify: Boolean; ResultAddress: Cardinal; ResultSize: Cardinal;
      ReturnCode: Integer);
    procedure ModifyComplete(const ExprStr: string; const ResultStr: string;
      ReturnCode: Integer);
    procedure ThreadNotify(Reason: TOTANotifyReason);
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
    { IOTAThreadNotifier160 }
    procedure EvaluateComplete(const ExprStr: string; const ResultStr: string;
      CanModify: Boolean; ResultAddress: TOTAAddress; ResultSize: LongWord;
      ReturnCode: Integer); overload;
  end;

type
  TGenericVisualierType = record
    TypeName: string;
    IsGeneric: Boolean;
  end;

const
  GenericVisualizerTypes: array [0 .. 4] of TGenericVisualierType = (
    (TypeName: 'MyGenericType.IGenericInterface<T,T2>'; IsGeneric: True),
    (TypeName: 'MyGenericType.TGenericClass<System.Integer>'; IsGeneric: False),
    (TypeName: 'MyGenericType.TGenericClass<T>'; IsGeneric: True),
    (TypeName: 'std::vector<T, Allocator>'; IsGeneric: True),
    (TypeName: 'std::map<K, V, Compare, Allocator>'; IsGeneric: True)
  );

  { TGenericVisualizer }

procedure TGenericVisualizer.AfterSave;
begin
  // don't care about this notification
end;

procedure TGenericVisualizer.BeforeSave;
begin
  // don't care about this notification
end;

procedure TGenericVisualizer.Destroyed;
begin
  // don't care about this notification
end;

procedure TGenericVisualizer.Modified;
begin
  // don't care about this notification
end;

procedure TGenericVisualizer.ModifyComplete(const ExprStr, ResultStr: string;
  ReturnCode: Integer);
begin
  // don't care about this notification
end;

procedure TGenericVisualizer.EvaluteComplete(const ExprStr, ResultStr: string;
  CanModify: Boolean; ResultAddress, ResultSize: Cardinal; ReturnCode: Integer);
begin
  EvaluateComplete(ExprStr, ResultStr, CanModify, TOTAAddress(ResultAddress),
    LongWord(ResultSize), ReturnCode);
end;

procedure TGenericVisualizer.EvaluateComplete(const ExprStr, ResultStr: string;
  CanModify: Boolean; ResultAddress: TOTAAddress; ResultSize: LongWord;
  ReturnCode: Integer);
begin
  FCompleted := True;
  if ReturnCode = 0 then
    FDeferredResult := ResultStr;
end;

procedure TGenericVisualizer.ThreadNotify(Reason: TOTANotifyReason);
begin
  // don't care about this notification
end;

function TGenericVisualizer.GetReplacementValue(const Expression, TypeName,
  EvalResult: string): string;
begin
  Result := 'Generic visualizer:' + '; ' +
    'Expression: ' + Expression + '; ' +
    'Type name: ' + TypeName + '; ' +
    'Evaluation: ' + EvalResult;
end;

function TGenericVisualizer.GetSupportedTypeCount: Integer;
begin
  Result := Length(GenericVisualizerTypes);
end;

procedure TGenericVisualizer.GetSupportedType(Index: Integer;
  var TypeName: string; var AllDescendants: Boolean);
begin
  AllDescendants := True;
  TypeName := GenericVisualizerTypes[index].TypeName;
end;

procedure TGenericVisualizer.GetSupportedType(Index: Integer;
  var TypeName: string; var AllDescendants: Boolean; var IsGeneric: Boolean);
begin
  AllDescendants := True;
  TypeName := GenericVisualizerTypes[index].TypeName;
  IsGeneric := GenericVisualizerTypes[index].IsGeneric;
end;

function TGenericVisualizer.GetVisualizerDescription: string;
begin
  Result := 'Sample on how to register a generic visualizer';
end;

function TGenericVisualizer.GetVisualizerIdentifier: string;
begin
  Result := ClassName;
end;

function TGenericVisualizer.GetVisualizerName: string;
begin
  Result := 'Sample Generic Visualizer';
end;

var
  GenericVis: IOTADebuggerVisualizer;

procedure Register;
begin
  GenericVis := TGenericVisualizer.Create;
  (BorlandIDEServices as IOTADebuggerServices).RegisterDebugVisualizer(GenericVis);
end;

procedure RemoveVisualizer;
var
  DebuggerServices: IOTADebuggerServices;
begin
  if Supports(BorlandIDEServices, IOTADebuggerServices, DebuggerServices) then
  begin
    DebuggerServices.UnregisterDebugVisualizer(GenericVis);
    GenericVis := nil;
  end;
end;

initialization

finalization
  RemoveVisualizer;

end.
