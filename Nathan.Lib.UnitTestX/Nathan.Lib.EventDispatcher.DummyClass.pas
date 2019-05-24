unit Nathan.Lib.EventDispatcher.DummyClass;

interface

{$M+}

type
  TInnerTestMethod  = procedure of object;

  IEventDummyClass = interface
    ['{830E8F1F-2CCE-4788-8299-7C1A4EF0D6DF}']
    procedure CheckException(AMethod: TInnerTestMethod);
    procedure Calling;
  end;

  TEventDummyClass = class(TInterfacedObject, IEventDummyClass)
  strict private
    FMethod: TInnerTestMethod;
  public
    procedure CheckException(AMethod: TInnerTestMethod);
    procedure Calling;
  end;


{$M-}

implementation

uses
  System.SysUtils;

{ **************************************************************************** }

{ TEventDummyClass }

procedure TEventDummyClass.Calling;
begin
  if Assigned(FMethod) then
    FMethod
  else
    raise Exception.Create('Any error message');
end;

procedure TEventDummyClass.CheckException(AMethod: TInnerTestMethod);
begin
  FMethod := AMethod;
end;

end.
