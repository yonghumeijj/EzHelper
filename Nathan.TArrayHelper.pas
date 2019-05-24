unit Nathan.TArrayHelper;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

{$M+}

type
  //  https://stackoverflow.com/questions/1600239/class-helper-for-generic-class
  //  https://stackoverflow.com/questions/22577119/arrays-in-tlist
  //  http://rvelthuis.de/articles/articles-openarr.html
  //  https://msdn.microsoft.com/de-de/library/system.array_methods(v=vs.110).aspx
  //  https://stackoverflow.com/questions/4922129/how-do-i-convert-an-array-to-a-listobject-in-c

  //  Helper looks like:
  //  https://msdn.microsoft.com/de-de/library/system.array_methods(v=vs.110).aspx
  //  https://msdn.microsoft.com/de-de/library/system.array(v=vs.110).aspx

  TArrayHelperOption = (ahoNone, ahoIgnoreDuplicates);
  TArrayHelperOptions = set of TArrayHelperOption;

  TTArrayHelperNathan = class helper for TArray
  public
    class function ToString<T>(const Source: TArray<T>): string; static;

    class function IndexOf<T>(const Source: array of T; const Value: T): Integer; overload;
    class function IndexOf<T>(const Source: array of T; const Value: T; const Comparer: IComparer<T>): Integer; overload;
    class function IndexOf<T>(const Source: array of T; const Value: T; const Comparer: IComparer<T>; StartIndex, Count: Integer): Integer; overload;

    class function LastIndexOf<T>(const Source: array of T; const Value: T): Integer; overload;
    class function LastIndexOf<T>(const Source: array of T; const Value: T; const Comparer: IComparer<T>): Integer; overload;
    class function LastIndexOf<T>(const Source: array of T; const Value: T; const Comparer: IComparer<T>; Index, Count: Integer): Integer; overload;

    class function ToList<T>(const Source: array of T): TList<T>;

    class procedure Clear<T>(var Source: TArray<T>); overload;
    class procedure Clear<T>(var Source: TArray<T>; Index, Count: Integer); overload;

    class function Clone<T>(const Source: TArray<T>): TArray<T>;

    class function Empty<T>(): TArray<T>;

    class function Find<T>(const Source: TArray<T>; Predicate: TPredicate<T>): T;
    class function FindAll<T>(const Source: TArray<T>; Predicate: TPredicate<T>): TArray<T>;

    class function FindIndex<T>(const Source: TArray<T>; Predicate: TPredicate<T>): Integer; overload;
    class function FindIndex<T>(const Source: TArray<T>; StartIndex: Integer; Predicate: TPredicate<T>): Integer; overload;
    class function FindIndex<T>(const Source: TArray<T>; StartIndex, Count: Integer; Predicate: TPredicate<T>): Integer; overload;

    class procedure ForEach<T>(Source: TArray<T>; Action: TProc<T>);

    class function Add<T>(var Source: TArray<T>; const Value: T): Integer; overload;
    class function Add<T>(var Source: TArray<T>; const Value: T; Options: TArrayHelperOptions): Integer; overload;

    class procedure Remove<T>(var Source: TArray<T>; const Value: T);
    class procedure RemoveAt<T>(var Source: TArray<T>; Index: Integer);

    function Filter<T>(Predicate: TPredicate<T>): TArray<T>;
  end;

{$M-}

implementation

uses
  System.TypInfo,
  System.Rtti,
  System.RTLConsts;

{ TTArrayHelperNathan }

class function TTArrayHelperNathan.ToList<T>(const Source: array of T): TList<T>;
var
  Idx: Integer;
begin
  Result := TList<T>.Create();

  for Idx := Low(Source) to High(Source) do
    Result.Add(Source[Idx]);
end;

class function TTArrayHelperNathan.ToString<T>(const Source: TArray<T>): string;
var
  Value: TValue;
  Each: TValue;
  Idx: Integer;
begin
  {$REGION 'Infos'}
    //  if TypeInfo(T) = TypeInfo(string) then
    //    Writeln(PTypeInfo(TypeInfo(T))^.Name);
    //  GetTypeKind(T).
    //  Value := TValue.From<T>(Source);
    //  Result := Value.ToString;
    //  Value := TValue.From<T>(Source);
    //  if (Value.Kind = tkInteger) then
    //    Result := Value.AsString;
    //  Result := TValue.ToString(Value);
  {$ENDREGION}

  Result := '';
  Value := TValue.From(Source);
  for Idx := 0 to Value.GetArrayLength - 1 do
  begin
    if (Idx > 0) then
      Result := Result + ', ';

    Each := value.GetArrayElement(Idx);
    Result := Result + Each.ToString;
  end;
end;

class function TTArrayHelperNathan.IndexOf<T>(const Source: array of T; const Value: T): Integer;
begin
  Result := IndexOf<T>(Source, Value, TComparer<T>.Default, 0, Length(Source))
end;

class function TTArrayHelperNathan.IndexOf<T>(const Source: array of T;
  const Value: T; const Comparer: IComparer<T>): Integer;
begin
  Result := IndexOf<T>(Source, Value, Comparer, 0, Length(Source))
end;

class function TTArrayHelperNathan.IndexOf<T>(const Source: array of T; const Value: T;
  const Comparer: IComparer<T>; StartIndex, Count: Integer): Integer;
var
  Idx: Integer;
begin
  if (StartIndex < Low(Source)) or (StartIndex + Count > Length(Source)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);

  Result := -1;
  for Idx := StartIndex to Count - 1 do
    if Comparer.Compare(Source[Idx], Value) = 0 then
      Exit(Idx);
end;

class function TTArrayHelperNathan.LastIndexOf<T>(const Source: array of T; const Value: T): Integer;
begin
  Result := LastIndexOf<T>(Source, Value, TComparer<T>.Default, 0, Length(Source))
end;

class function TTArrayHelperNathan.LastIndexOf<T>(const Source: array of T;
  const Value: T; const Comparer: IComparer<T>): Integer;
begin
  Result := LastIndexOf<T>(Source, Value, Comparer, 0, Length(Source))
end;

class function TTArrayHelperNathan.LastIndexOf<T>(const Source: array of T;
  const Value: T; const Comparer: IComparer<T>; Index, Count: Integer): Integer;
var
  Idx: Integer;
begin
  if (Index < Low(Source)) or (Index + Count > Length(Source)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);

  Result := -1;
  for Idx := High(Source) downto Low(Source) do
    if Comparer.Compare(Source[Idx], Value) = 0 then
      Exit(Idx);
end;

class procedure TTArrayHelperNathan.Remove<T>(var Source: TArray<T>; const Value: T);
begin
  RemoveAt<T>(Source, IndexOf(Source, Value));
end;

class procedure TTArrayHelperNathan.RemoveAt<T>(var Source: TArray<T>; Index: Integer);
begin
  if (Index > Length(Source)) then
    raise EArgumentOutOfRangeException.CreateRes(@SArgumentOutOfRange);

  Delete(Source, Index, 1);
end;

class procedure TTArrayHelperNathan.Clear<T>(var Source: TArray<T>);
begin
  Clear<T>(Source, Low(Source), Length(Source));
end;

class function TTArrayHelperNathan.Add<T>(var Source: TArray<T>; const Value: T): Integer;
begin
  Result := Length(Source) + 1;
  Insert(Value, Source, Result);
end;

class function TTArrayHelperNathan.Add<T>(var Source: TArray<T>; const Value: T; Options: TArrayHelperOptions): Integer;
begin
  if (ahoIgnoreDuplicates in Options) then
  begin
    Result := IndexOf<T>(Source, Value);
    if (Result > -1) then
      Exit;
  end;

  Result := Length(Source) + 1;
  Insert(Value, Source, Result);
end;

class procedure TTArrayHelperNathan.Clear<T>(var Source: TArray<T>; Index, Count: Integer);
begin
  if (Count = 0) then
    Exit;

  Assert((Index >= Low(Source)) and (Index <= High(Source)));
  Delete(Source, Index, Count);
end;

class function TTArrayHelperNathan.Clone<T>(const Source: TArray<T>): TArray<T>;
begin
  SetLength(Result, Length(Source));
  TArray.Copy<T>(Source, Result, Length(Source))
end;

class function TTArrayHelperNathan.Empty<T>: TArray<T>;
begin
  Result := [];
end;

class function TTArrayHelperNathan.Find<T>(const Source: TArray<T>; Predicate: TPredicate<T>): T;
var
  Idx: Integer;
begin
  Result := Default(T);
  for Idx := High(Source) downto Low(Source) do
  begin
    if Predicate(Source[Idx]) then
      Exit(Source[Idx]);
  end;
end;

class function TTArrayHelperNathan.FindAll<T>(const Source: TArray<T>; Predicate: TPredicate<T>): TArray<T>;
var
  Idx: Integer;
begin
  for Idx := Low(Source) to High(Source) do
  begin
    if Assigned(Predicate) and Predicate(Source[Idx]) then
      Insert(Source[Idx], Result, Length(Result));
  end;
end;

class function TTArrayHelperNathan.FindIndex<T>(const Source: TArray<T>; Predicate: TPredicate<T>): Integer;
begin
  Result := FindIndex<T>(Source, 0, Predicate);
end;

class function TTArrayHelperNathan.FindIndex<T>(const Source: TArray<T>;
  StartIndex: Integer; Predicate: TPredicate<T>): Integer;
begin
  Result := FindIndex<T>(Source, StartIndex, Length(Source), Predicate);
end;

class function TTArrayHelperNathan.FindIndex<T>(const Source: TArray<T>;
  StartIndex, Count: Integer; Predicate: TPredicate<T>): Integer;
var
  Idx: Integer;
begin
  if (StartIndex < Low(Source)) or (Count > Length(Source)) then
    raise EArgumentOutOfRangeException.Create(SArgumentOutOfRange);

  Result := -1;
  for Idx := StartIndex to Count - 1 do
    if Assigned(Predicate) and Predicate(Source[Idx]) then
      Exit(Idx);
end;

class procedure TTArrayHelperNathan.ForEach<T>(Source: TArray<T>; Action: TProc<T>);
var
  Idx: Integer;
begin
  for Idx := High(Source) downto Low(Source) do
    Action(Source[Idx]);
end;

function TTArrayHelperNathan.Filter<T>(Predicate: TPredicate<T>): TArray<T>;
var
  Idx: Integer;
begin
  Result := Empty<T>;
  for Idx := High(TArray<T>(Self)) downto Low(TArray<T>(Self)) do
  begin
    if (Assigned(Predicate) and Predicate(TArray<T>(Self)[Idx])) then
      Insert(TArray<T>(Self)[Idx], Result, Length(Result));
  end;
end;

end.
