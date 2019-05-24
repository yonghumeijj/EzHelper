unit Nathan.SmartPointer;

interface

type
  INathanSmartPointer<T> = reference to function: T;

  /// <summary>
  ///   Inspired by the book of "Delphi Memory Management for Classic and ARC Compilers"
  ///   from Dalija Prasnikar and Neven Prasnikar...
  ///   https://adugmembers.wordpress.com/2011/12/05/smart-pointers/
  /// </summary>
  TNathanSmartPointer<T: class, constructor> = class(TInterfacedObject, INathanSmartPointer<T>)
  private
    FUnmanagedClass: T;
    function Invoke: T;
  public
    constructor Create(); overload;
    constructor Create(AUnmanagedClass: T); overload;

    destructor Destroy(); override;

    function Extract: T;
  end;

implementation

{ TNathanSmartPointer<T> }

constructor TNathanSmartPointer<T>.Create();
begin
  inherited Create();
  FUnmanagedClass := T.Create;
end;

constructor TNathanSmartPointer<T>.Create(AUnmanagedClass: T);
begin
  inherited Create();

  if Assigned(AUnmanagedClass) then
    FUnmanagedClass := AUnmanagedClass
  else
    FUnmanagedClass := T.Create;
end;

destructor TNathanSmartPointer<T>.Destroy();
//var
//  temp: TObject;
begin
  FUnmanagedClass.Free();

  //  At the moment I'm not sure how to find out if the object has
  //  already been freeing. It will be critcal to call free again.
  //  if Assigned(FUnmanagedClass) then
  //  begin
  //    FUnmanagedClass := nil;
  //    FUnmanagedClass.Free;
  //    temp := TObject(FUnmanagedClass);
  //    Pointer(FUnmanagedClass) := Pointer(1);
  //    temp.Free;
  //  end;

  inherited;
end;

function TNathanSmartPointer<T>.Extract(): T;
begin
  Result := FUnmanagedClass;
  FUnmanagedClass := nil;
end;

function TNathanSmartPointer<T>.Invoke(): T;
begin
  Result := FUnmanagedClass;
end;

end.
