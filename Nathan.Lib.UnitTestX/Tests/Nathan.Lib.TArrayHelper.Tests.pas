unit Nathan.Lib.TArrayHelper.Tests;

interface

uses
  System.Classes,
  DUnitX.TestFramework;

{$M+}

type
  [TestFixture]
  TTestTArrayHelper = class
  private
    FCut: TObject;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_Starter();

    [Test]
    procedure Test_ToList();

    [Test]
    procedure Test_Clear_Basic();

    [Test]
    procedure Test_Clear_AllDirect();

    [Test]
    procedure Test_Clear_ByEmptyList();

    [Test]
    procedure Test_Clone_Basic();

    [Test]
    procedure Test_Clone_DeleteValuesFromSourceAfter();

    [Test]
    procedure Test_IndexOf_Basic();

    [Test]
    procedure Test_LastIndexOf_Basic();

    [Test]
    procedure Test_LastIndexOf_DontFound();

    [Test]
    procedure Test_IndexOf_EmptyArray();

    [Test]
    procedure Test_IndexOf_DontFound();

    [Test]
    procedure Test_ToString();

    [Test]
    procedure Test_Find_Basic();

    [Test]
    procedure Test_FindAll_Basic();

    [Test]
    procedure Test_Find_DontFindAnything();

    [Test]
    procedure Test_ForEach_Basic();

    [Test]
    procedure Test_FindIndex_Pred_Basic();

    [Test]
    [TestCase('FindIndex01', '0,7')]
    [TestCase('FindIndex02', '3,7')]
    [TestCase('FindIndex03', '8,-1')]
    procedure Test_FindIndex_Pred__StartIndex_Basic(Value, Expected: Integer);

    [Test]
    procedure Test_FindIndex_Pred_WillRaise();

    [Test]
    procedure Test_FindIndex_Pred_WillNotRaise();

    [Test]
    procedure Test_FindIndex_Pred_WillNotRaise_WithoutPred();

    [Test]
    procedure Test_Add_Basic();

    [Test]
    procedure Test_Add_WithOption_ahoIgnoreDuplicates();

    [Test]
    procedure Test_Add_WithOption_ahoIgnoreDuplicates_AndInsert();

    [Test]
    procedure Test_RemoveAt_Basic();

    [Test]
    procedure Test_RemoveAt_BasicEx();

    [Test]
    procedure Test_Remove_Basic();

    [Test]
    procedure Test_Empty();

    [Test]
    procedure Test_Filter();
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Nathan.TArrayHelper;

{ TTestTArrayHelper }

procedure TTestTArrayHelper.SetUp;
begin
  FCut := nil;
end;

procedure TTestTArrayHelper.TearDown;
begin
  FCut := nil;
end;

procedure TTestTArrayHelper.Test_Starter();
const
  Expected = '1, 2, 3';
var
  Mut: TArray<Integer>;  //  Method under test...
  Actual: string;
begin
  Mut := [1, 2, 3];

  Actual := TArray.ToString<Integer>(Mut);
  Assert.AreEqual(Expected, Actual);
end;

procedure TTestTArrayHelper.Test_ToList;
var
  Mut: TArray<Integer>;  //  Method under test...
  Actual: TList<Integer>;
begin
  Mut := [1, 2, 3];

  Actual := TArray.ToList<Integer>(Mut);
  try
    Assert.AreEqual(3, Actual.Count);
    Assert.AreEqual(1, Actual[0]);
  finally
    Actual.Free;
  end;
end;

procedure TTestTArrayHelper.Test_Clear_Basic();
var
  Mut: TArray<Integer>;  //  Method under test...
begin
  //  Arrange...
  Mut := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  //  Act...
  TArray.Clear<Integer>(Mut, 5, 2);

  //  Assert...
  Assert.AreEqual(8, Length(Mut));
  Assert.AreEqual(7, Mut[5]);
  Assert.AreEqual(8, Mut[6]);
  Assert.AreEqual(9, Mut[7]);
end;

procedure TTestTArrayHelper.Test_Clear_AllDirect();
var
  Mut: TArray<Integer>;
begin
  //  Arrange...
  Mut := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  //  Act...
  TArray.Clear<Integer>(Mut);

  //  Assert...
  Assert.AreEqual(0, Length(Mut));
end;

procedure TTestTArrayHelper.Test_Clear_ByEmptyList;
var
  Mut: TArray<Integer>;
begin
  //  Arrange...
  Mut := [];

  //  Act...
  TArray.Clear<Integer>(Mut);

  //  Assert...
  Assert.AreEqual(0, Length(Mut));
end;

procedure TTestTArrayHelper.Test_Clone_Basic;
var
  Mut: TArray<Integer>;
  Actual: TArray<Integer>;
begin
  //  Arrange...
  Mut := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  //  Act...
  Actual := TArray.Clone<Integer>(Mut);

  //  Assert...
  Assert.AreEqual(Length(Mut), Length(Actual));
end;

procedure TTestTArrayHelper.Test_Clone_DeleteValuesFromSourceAfter;
var
  Mut: TArray<Integer>;
  Actual: TArray<Integer>;
begin
  //  Arrange...
  Mut := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  //  Act...
  Actual := TArray.Clone<Integer>(Mut);
  TArray.Clear<Integer>(Mut, 5, 2);

  //  Assert...
  Assert.AreEqual(8, Length(Mut));
  Assert.AreEqual(10, Length(Actual));
end;

procedure TTestTArrayHelper.Test_IndexOf_Basic();
var
  Mut: TArray<Integer>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

  //  Act...
  Actual := TArray.IndexOf<Integer>(Mut, 7);

  //  Assert...
  Assert.AreEqual(6, Actual);
end;

procedure TTestTArrayHelper.Test_IndexOf_DontFound;
var
  Mut: TArray<Integer>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

  //  Act...
  Actual := TArray.IndexOf<Integer>(Mut, 77);

  //  Assert...
  Assert.AreEqual(-1, Actual);
end;

procedure TTestTArrayHelper.Test_IndexOf_EmptyArray();
var
  Mut: TArray<Integer>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := [];

  //  Act...
  Actual := TArray.IndexOf<Integer>(Mut, 7);

  //  Assert...
  Assert.AreEqual(-1, Actual);
end;

procedure TTestTArrayHelper.Test_LastIndexOf_Basic();
var
  Mut: TArray<string>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := ['0', '1', '2', '3', '7', '4', '5', '6', '7', '8', '9'];

  //  Act...
  Actual := TArray.LastIndexOf<string>(Mut, '7');

  //  Assert...
  Assert.AreEqual(8, Actual);
end;

procedure TTestTArrayHelper.Test_LastIndexOf_DontFound;
var
  Mut: TArray<Double>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := [0.12, 1.23, 3.45];

  //  Act...
  Actual := TArray.LastIndexOf<Double>(Mut, 4.56);

  //  Assert...
  Assert.AreEqual(-1, Actual);
end;

procedure TTestTArrayHelper.Test_ToString();
const
  Expected = '1.25, 2.87, 3.55';
var
  Mut: TArray<Double>;
  Actual: string;
begin
  //  Arrange...
  Mut := [1.25, 2.87, 3.55];

  //  Act...
  Actual := TArray.ToString<Double>(Mut);

  //  Assert...
  Assert.AreEqual('1.25, 2.87, 3.55', Actual);
end;

procedure TTestTArrayHelper.Test_Find_Basic();
var
  Mut: TArray<string>;
  Actual: string;
  p: TPredicate<string>;
begin
  //  Arrange...
  Mut := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  p :=
    function(Arg: string): Boolean
    begin
      Result := Arg.Contains('7');
    end;

  //  Act...
  Actual := TArray.Find<string>(Mut, p);

  //  Assert...
  Assert.AreEqual('7', Actual);
end;

procedure TTestTArrayHelper.Test_FindAll_Basic;
var
  Mut: TArray<Integer>;
  Actual: TArray<Integer>;
begin
  //  Arrange...
  Mut := [1, 2, 3, 4, 5, 6, 7, 8, 9];

  //  Act...
  Actual := TArray.FindAll<Integer>(
    Mut,
    function(Arg: Integer): Boolean
    begin
      Result := ((Arg mod 2) = 0);
    end);

  //  Assert...
  Assert.AreEqual(4, Length(Actual));
  Assert.AreEqual(2, Actual[0]);
  Assert.AreEqual(4, Actual[1]);
  Assert.AreEqual(6, Actual[2]);
  Assert.AreEqual(8, Actual[3]);
end;

procedure TTestTArrayHelper.Test_Find_DontFindAnything();
var
  Mut: TArray<TStringList>;
  StringList1: TStringList;
  StringList2: TStringList;
  Actual: TStringList;
begin
  //  Arrange...
  StringList1 := TStringList.Create;
  StringList1.Add('1');

  StringList2 := TStringList.Create;
  StringList2.Add('2');

  try
    Mut := [StringList1, StringList2];

    //  Act...
    Actual := TArray.Find<TStringList>(
      Mut,
      function(Arg: TStringList): Boolean
      begin
        Result := Arg.Text.Contains('Nathan');
      end);

    //  Assert...
    Assert.IsNull(Actual);
  finally
    StringList1.Free();
    StringList2.Free();
  end;
end;

procedure TTestTArrayHelper.Test_ForEach_Basic();
var
  Mut: TArray<Integer>;
  Actual: Integer;
begin
  //  Arrange...
  Actual := -1;
  Mut := [1, 2, 3];

  //  Act...
  TArray.ForEach<Integer>(
    Mut,
    procedure(Arg: Integer)
    begin
      if Arg = 2 then
        Actual := Arg;
    end);

  //  Assert...
  Assert.AreEqual(2, Actual);
end;

procedure TTestTArrayHelper.Test_FindIndex_Pred_Basic();
var
  Mut: TArray<string>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  //  Act...
  Actual := TArray.FindIndex<string>(
    Mut,
    function(Arg: string): Boolean
    begin
      Result := Arg.Contains('7');
    end);

  //  Assert...
  Assert.AreEqual(7, Actual);
end;

procedure TTestTArrayHelper.Test_FindIndex_Pred__StartIndex_Basic(Value, Expected: Integer);
var
  Mut: TArray<string>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  //  Act...
  Actual := TArray.FindIndex<string>(
    Mut,
    Value,
    function(Arg: string): Boolean
    begin
      Result := Arg.Contains('7');
    end);

  //  Assert...
  Assert.AreEqual(Expected, Actual);
end;

procedure TTestTArrayHelper.Test_FindIndex_Pred_WillRaise();
var
  Mut: TArray<string>;
begin
  //  Arrange...
  Mut := ['0', '1', '2'];

  //  Act...
  //  Assert...
  Assert.WillRaise(procedure
    begin
      TArray.FindIndex<string>(Mut, 0, 10, nil);
    end, EArgumentOutOfRangeException);

  Assert.WillRaise(procedure
    begin
      TArray.FindIndex<string>(Mut, -1, 3, nil);
    end, EArgumentOutOfRangeException);
end;

procedure TTestTArrayHelper.Test_FindIndex_Pred_WillNotRaise;
var
  Mut: TArray<string>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := ['0', '1', '2'];

  //  Act...
  Assert.WillNotRaiseAny(
    procedure
    begin
      Actual := TArray.FindIndex<string>(Mut, 4, 3, nil);
    end);

  //  Assert...
  Assert.AreEqual(-1, Actual);
end;

procedure TTestTArrayHelper.Test_FindIndex_Pred_WillNotRaise_WithoutPred();
var
  Mut: TArray<string>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := ['0', '1', '2'];

  //  Act...
  Assert.WillNotRaiseAny(
    procedure
    begin
      Actual := TArray.FindIndex<string>(Mut, 0, 3, nil);
    end);

  //  Assert...
  Assert.AreEqual(-1, Actual);
end;

procedure TTestTArrayHelper.Test_Add_Basic();
var
  Mut: TArray<string>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := ['0', '1', '2'];

  //  Act...
  Actual := TArray.Add<string>(Mut, 'Chanan');

  //  Assert...
  Assert.AreEqual(4, Actual);
  Assert.AreEqual('0', Mut[0]);
  Assert.AreEqual('1', Mut[1]);
  Assert.AreEqual('2', Mut[2]);
  Assert.AreEqual('Chanan', Mut[3]);
end;

procedure TTestTArrayHelper.Test_Add_WithOption_ahoIgnoreDuplicates;
var
  Mut: TArray<Double>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := [0.99, 1.25, 2.75];

  //  Act...
  Actual := TArray.Add<Double>(Mut, 1.25, [ahoIgnoreDuplicates]);

  //  Assert...
  Assert.AreEqual(1, Actual);
  Assert.AreEqual(0.99, Mut[0], 1);
  Assert.AreEqual(1.25, Mut[1], 1);
  Assert.AreEqual(2.75, Mut[2], 1);
end;

procedure TTestTArrayHelper.Test_Add_WithOption_ahoIgnoreDuplicates_AndInsert;
var
  Mut: TArray<string>;
  Actual: Integer;
begin
  //  Arrange...
  Mut := ['Nathan', 'Chanan'];

  //  Act...
  Actual := TArray.Add<string>(Mut, 'Thurnreiter', [ahoIgnoreDuplicates]);

  //  Assert...
  Assert.AreEqual(3, Actual);
  Assert.AreEqual('Nathan', Mut[0]);
  Assert.AreEqual('Chanan', Mut[1]);
  Assert.AreEqual('Thurnreiter', Mut[2]);
end;

procedure TTestTArrayHelper.Test_RemoveAt_Basic();
var
  Mut: TArray<string>;
begin
  //  Arrange...
  Mut := ['0', '1', '2'];

  //  Act...
  TArray.RemoveAt<string>(Mut, 1);

  //  Assert...
  Assert.AreEqual(2, Length(Mut));
  Assert.AreEqual('0', Mut[0]);
  Assert.AreEqual('2', Mut[1]);
end;

procedure TTestTArrayHelper.Test_RemoveAt_BasicEx();
var
  Mut: TArray<string>;
begin
  //  Arrange...
  Mut := ['0', '1', '2'];

  //  Act...
  Assert.WillRaise(procedure
    begin
      TArray.RemoveAt<string>(Mut, 11);
    end,
    EArgumentOutOfRangeException);

  //  Assert...
  Assert.AreEqual(3, Length(Mut));
  Assert.AreEqual('0', Mut[0]);
  Assert.AreEqual('1', Mut[1]);
  Assert.AreEqual('2', Mut[2]);
end;

procedure TTestTArrayHelper.Test_Remove_Basic();
var
  Mut: TArray<string>;
begin
  //  Arrange...
  Mut := ['0', '1', '2'];

  //  Act...
  TArray.Remove<string>(Mut, '1');

  //  Assert...
  Assert.AreEqual(2, Length(Mut));
  Assert.AreEqual('0', Mut[0]);
  Assert.AreEqual('2', Mut[1]);
end;

procedure TTestTArrayHelper.Test_Empty;
var
  Mut: TArray<Integer>;
begin
  //  Arrange...
  //  Act...
  Mut := TArray.Empty<Integer>;

  //  Assert...
  Assert.AreEqual(0, Length(Mut));
end;

procedure TTestTArrayHelper.Test_Filter;
var
  Actual: TArray<Integer>;
  //  Cut: TArray;
begin
  //  Arrange...
  Actual := [0, 1, 2];

  //  Act...
  //  Cut.Filter()
  Actual := TArray(Actual).Filter<Integer>(
    function(Arg: Integer): Boolean
    begin
      Result := (Arg = 1);
    end);

  //  Assert...
  Assert.AreEqual(1, Length(Actual));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTArrayHelper, 'TArrayHelper');

end.
