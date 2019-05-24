unit Nathan.Lib.SmartPointer.Tests;

interface

uses
  System.Classes,
  DUnitX.TestFramework;

{$M+}

type
  [TestFixture]
  TTestSmartPointer = class
  published
    [Test]
    procedure Test_Unmanaged_StarterWithoutSmartPointer();

    [Test]
    procedure Test_Managed_ToUseSmartPointer();

    [Test]
    procedure Test_Managed_OverloadedConstructor();

    [Test]
    procedure Test_Managed_FirstCreatedByHisOwn();

    [Test]
    procedure Test_Managed_ConstructorWithNil();

    [Test]
    procedure Test_Managed_CallingServalTimesAMethod();

    [Test]
    procedure Test_Managed_WhatHappensWhenICallFree();
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Nathan.SmartPointer;

{ TTestSmartPointer }

procedure TTestSmartPointer.Test_Unmanaged_StarterWithoutSmartPointer();
var
  Cut: TStringList;
begin
  Cut := TStringList.Create();
  try
    Cut.Add('Any text from test...');
    Assert.IsNotNull(Cut);
  finally
    Cut.Free();
  end;
end;

procedure TTestSmartPointer.Test_Managed_ToUseSmartPointer();
var
  Cut: INathanSmartPointer<TStringList>;
begin
  Cut := TNathanSmartPointer<TStringList>.Create();
  Cut.Add('Any more text from test...');
  Assert.IsNotNull(Cut);
  Assert.IsFalse(Cut.OwnsObjects);
end;

procedure TTestSmartPointer.Test_Managed_OverloadedConstructor();
var
  Cut: INathanSmartPointer<TStringList>;
begin
  //  Typical using when creating a new object instance to manage code...
  Cut := TNathanSmartPointer<TStringList>.Create(TStringList.Create(True));
  Cut.Add('Any more text from test...');
  Assert.IsNotNull(Cut);
  Assert.IsTrue(Cut.OwnsObjects);
end;

procedure TTestSmartPointer.Test_Managed_FirstCreatedByHisOwn();
var
  Actual: TStringList;
  Cut: INathanSmartPointer<TStringList>;
begin
  Actual := TStringList.Create();
  Actual.Add('First');

  Cut := TNathanSmartPointer<TStringList>.Create(Actual);
  Cut.Add('Second');

  Assert.IsNotNull(Cut);
  Assert.IsFalse(Cut.OwnsObjects);
  Assert.AreEqual('First', Cut[0]);
  Assert.AreEqual('Second', Cut[1]);
end;

procedure TTestSmartPointer.Test_Managed_ConstructorWithNil();
var
  Cut: INathanSmartPointer<TStringList>;
begin
  Assert.WillNotRaise(
    procedure
    begin
      Cut := TNathanSmartPointer<TStringList>.Create(nil);
      Cut.Add('Any text...');
    end);
end;

procedure TTestSmartPointer.Test_Managed_CallingServalTimesAMethod;
var
  Cut: INathanSmartPointer<TStringList>;
begin
  Cut := TNathanSmartPointer<TStringList>.Create(TStringList.Create(True));
  Cut.Add('Any more text from test.');
  Cut.Text := Cut.Text + ' Here I am.';
  Assert.IsNotNull(Cut);
  Assert.IsTrue(Cut.OwnsObjects);
  Assert.AreEqual('Any more text from test.'#$D#$A' Here I am.'#$D#$A, Cut.Text);
end;

procedure TTestSmartPointer.Test_Managed_WhatHappensWhenICallFree();
var
  Cut: INathanSmartPointer<TStringList>;
begin
  Cut := TNathanSmartPointer<TStringList>.Create(TStringList.Create(True));
  Cut.Add('Any more text from test.');
  Assert.IsNotNull(Cut);
  //  Cut.Free;
  Assert.IsTrue(1 = 1);
  //  Puh memory leeks, what for a suprise...
end;

initialization
  TDUnitX.RegisterTestFixture(TTestSmartPointer, 'TTestSmartPointer');

end.
