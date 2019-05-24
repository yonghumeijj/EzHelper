unit Nathan.EventDispatcher;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

{$M+}

type
  {$REGION 'Demo'}
  //  http://tech.turbu-rpg.com/30/under-the-hood-of-an-anonymous-method
  //  https://stackoverflow.com/questions/39955052/how-are-anonymous-methods-implemented-under-the-hood
  //  http://www.deltics.co.nz/blog/posts/586
  //  https://stackoverflow.com/questions/17533381/assign-an-anonymous-method-to-an-interface-variable-or-parameter

  //  INathanEventDispatcher = interface
  //    ['{E2DFECB0-831E-4F56-85D7-46AC4D9A77EE}']
  //    function Attach(Closure: TProc): TInnerTestMethod;
  //  end;
  //
  //  TNathanEventDispatcher = class(TInterfacedObject, INathanEventDispatcher)
  //  strict private
  //    class var FInstance: INathanEventDispatcher;
  //  strict protected
  //    FClosure: TProc;
  //    procedure OnEvent();
  //  public
  //    class function Construct(Closure: TProc): TInnerTestMethod;
  //
  //    function Attach(Closure: TProc): TInnerTestMethod;
  //  end;
  {$ENDREGION}

  TInnerProcedureOfObject = procedure of object;
  TInnerProcOfObj = type TInnerProcedureOfObject;

  INathanEventDispatcher<T> = interface
    ['{629122A7-4D07-432D-B638-3F2A0D0AC88E}']
    function Attach(Closure: TProc): TInnerProcOfObj;
  end;

  TNathanEventDispatcher<T> = class(TInterfacedObject, INathanEventDispatcher<T>)
  strict private
    class var FInstance: INathanEventDispatcher<T>;
  strict protected
    FClosure: TProc;
    procedure OnEvent();
  public
    class function Construct(Closure: TProc): TInnerProcOfObj;

    function Attach(Closure: TProc): TInnerProcOfObj;
  end;

{$M-}

implementation

{$REGION 'Demo'}
//{ TNathanEventDispatcher }
//
//class function TNathanEventDispatcher.Construct(Closure: TProc): TInnerTestMethod;
//begin
//  if (not Assigned(FInstance)) then
//    FInstance := TNathanEventDispatcher.Create;
//
//  Result := FInstance.Attach(Closure);
//end;
//
//function TNathanEventDispatcher.Attach(Closure: TProc): TInnerTestMethod;
//begin
//  FClosure := Closure;
//  Result := OnEvent;
//end;
//
//procedure TNathanEventDispatcher.OnEvent;
//begin
//  if Assigned(FClosure) then
//    FClosure()
//end;
{$ENDREGION}

{ TNathanEventDispatcherT<T> }

class function TNathanEventDispatcher<T>.Construct(Closure: TProc): TInnerProcOfObj;
begin
  if (not Assigned(FInstance)) then
    FInstance := TNathanEventDispatcher<T>.Create;

  Result := FInstance.Attach(Closure);
end;

function TNathanEventDispatcher<T>.Attach(Closure: TProc): TInnerProcOfObj;
begin
  FClosure := Closure;
  Result := OnEvent;  //  Result := (IInterface(Pointer(@OnEvent)^)) as T;
end;

procedure TNathanEventDispatcher<T>.OnEvent;
begin
  if Assigned(FClosure) then
    FClosure;
end;

end.
