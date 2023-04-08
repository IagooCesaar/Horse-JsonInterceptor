unit Test.Horse.JsonInterceptor.API;

interface

uses
  DUnitX.TestFramework,
  RESTRequest4D,
  App;

type
  [TestFixture]
  TestTHorseJsonInterceptorAPI = class
  private
    FApp: TApp;
    function BaseRequest: IRequest;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_Lib_Familia_Post;

    [Test]
    procedure Test_Helper_Familia_Post;

    [Test]
    procedure Test_Middleware_Familia_Post;
  end;

implementation

uses
  Horse.JsonInterceptor.Example.Classes,
  Horse.JsonInterceptor.Helpers,
  System.SysUtils;


function TestTHorseJsonInterceptorAPI.BaseRequest: IRequest;
begin
  Result := TRequest.New
    .BaseURL(FApp.BaseURL);
end;


procedure TestTHorseJsonInterceptorAPI.Setup;
begin
end;

procedure TestTHorseJsonInterceptorAPI.SetupFixture;
begin
  FApp := TApp.Create;
  FApp.Start;
end;

procedure TestTHorseJsonInterceptorAPI.TearDown;
begin
end;

procedure TestTHorseJsonInterceptorAPI.TearDownFixture;
begin
  FApp.Stop;
  FApp.Free;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Familia_Post;
var LFamilia, LFamiliaResp : TFamilia; LResponse: IResponse;
begin
  LFamilia := Mock_Familia;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/familia')
      .AddBody(TJson.ObjectToClearJsonString(LFamilia))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LFamilia);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Familia_Post;
var LFamilia, LFamiliaResp : TFamilia; LResponse: IResponse;
begin
  LFamilia := Mock_Familia;
  try
    LResponse := BaseRequest
      .Resource('/with-lib/familia')
      .AddBody(TJson.ObjectToClearJsonString(LFamilia))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LFamilia);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Familia_Post;
var LFamilia, LFamiliaResp : TFamilia; LResponse: IResponse;
begin
  LFamilia := Mock_Familia;
  try
    LResponse := BaseRequest
      .Resource('/with-middleware/familia')
      .AddBody(TJson.ObjectToClearJsonString(LFamilia))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LFamilia);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTHorseJsonInterceptorAPI);

end.
