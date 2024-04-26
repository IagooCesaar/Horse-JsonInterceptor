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
    procedure Test_Lib_Biblioteca_Post;

    [Test]
    procedure Test_Lib_Empresa_Post;

    [Test]
    procedure Test_Lib_Escola_Post;

    [Test]
    procedure Test_Lib_Garagem_Post;

    [Test]
    procedure Test_Lib_Pessoas_Post;

    [Test]
    procedure Test_Lib_Todos_Post;

    [Test]
    procedure Test_Lib_Familia_Post;

    [Test]
    procedure Test_Helper_Biblioteca_Post;

    [Test]
    procedure Test_Helper_Empresa_Post;

    [Test]
    procedure Test_Helper_Escola_Post;

    [Test]
    procedure Test_Helper_Familia_Post;

    [Test]
    procedure Test_Helper_Garagem_Post;

    [Test]
    procedure Test_Helper_Pessoas_Post;

    [Test]
    procedure Test_Helper_Musica_Post;

    [Test]
    procedure Test_Helper_Musica_Post_PropriedadeIncorreta;

    [Test]
    procedure Test_Helper_Musica_Post_PropriedadeOmitida;

    [Test]
    procedure Test_Helper_Todos_Post;


    [Test]
    procedure Test_Middleware_Familia_Post;

    [Test]
    procedure Test_Middleware_Biblioteca_Post;

    [Test]
    procedure Test_Middleware_Empresa_Post;

    [Test]
    procedure Test_Middleware_Garagem_Post;

    [Test]
    procedure Test_Middleware_Escola_Post;

    [Test]
    procedure Test_Middleware_Pessoas_Post;

    [Test]
    procedure Test_Middleware_Todos_Post;
  end;

implementation

uses
  Horse,
  Horse.JsonInterceptor.Example.Classes,
  Horse.JsonInterceptor.Helpers,
  System.SysUtils,
  System.JSON;


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


procedure TestTHorseJsonInterceptorAPI.Test_Helper_Biblioteca_Post;
var LBiblioteca : TBiblioteca; LResponse: IResponse;
begin
  LBiblioteca := Mock_Biblioteca;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/biblioteca')
      .AddBody(TJson.ObjectToClearJsonString(LBiblioteca))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LBiblioteca);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Empresa_Post;
var LEmpresa : TEmpresa; LResponse: IResponse;
begin
  LEmpresa := Mock_Empresa;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/empresa')
      .AddBody(TJson.ObjectToClearJsonString(LEmpresa))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LEmpresa);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Escola_Post;
var LEscola: TEscola; LResponse: IResponse;
begin
  LEscola := Mock_Escola;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/escola')
      .AddBody(TJson.ObjectToClearJsonString(LEscola))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LEscola);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Familia_Post;
var LFamilia : TFamilia; LResponse: IResponse;
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

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Garagem_Post;
var LGaragem: TGaragem; LResponse: IResponse;
begin
  LGaragem := Mock_Garagem;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/garagem')
      .AddBody(TJson.ObjectToClearJsonString(LGaragem))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LGaragem);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Musica_Post;
var LMusica: TMusica; LResponse: IResponse;
begin
  LMusica := Mock_Musica;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/musica')
      .AddBody(TJson.ObjectToClearJsonString(LMusica))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);

  finally
    FreeAndNil(LMusica);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Musica_Post_PropriedadeIncorreta;
var
  LJsonString: string;
  LMusica: TMusica;
  LResponse: IResponse;
  LErro: TJSONObject;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Nome da música", '
  + '	"album": "Nome do álbum", '
  + '	"artista": "Nome do artista", '
  + '	"tempo": "00:00" '
  + '} '
  ;
  LMusica := TJson.ClearJsonAndConvertToObject<TMusica>(LJsonString);

  try
    LResponse := BaseRequest
      .Resource('/with-helper/musica')
      .AddBody(TJson.ObjectToClearJsonString(LMusica))
      .Post();

    Assert.AreEqual(Integer(THTTPStatus.PreconditionFailed),
      LResponse.StatusCode, LResponse.StatusText);

    LErro := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
    Assert.Contains(LErro.GetValue<string>('error'), 'O Tempo de execução deverá ser superior a "00:00"');
    LErro.Free;

  finally
    FreeAndNil(LMusica);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Musica_Post_PropriedadeOmitida;
var
  LJsonString: string;
  LMusica: TMusica;
  LResponse: IResponse;
  LErro: TJSONObject;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Nome da música", '
  + '	"album": "Nome do álbum", '
  + '	"tempo": "00:06:00" '
  + '} '
  ;
  LMusica := TJson.ClearJsonAndConvertToObject<TMusica>(LJsonString);

  try
    LResponse := BaseRequest
      .Resource('/with-helper/musica')
      .AddBody(TJson.ObjectToClearJsonString(LMusica))
      .Post();

    Assert.AreEqual(Integer(THTTPStatus.PreconditionFailed),
      LResponse.StatusCode, LResponse.StatusText);

    LErro := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
    Assert.Contains(LErro.GetValue<string>('error'), 'O Nome do Artista deverá ter no mínimo');
    LErro.Free;

  finally
    FreeAndNil(LMusica);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Pessoas_Post;
var LPessoas: TPessoas; LResponse: IResponse;
begin
  LPessoas := Mock_Pessoas;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/pessoas')
      .AddBody(TJson.ObjectToClearJsonString(LPessoas))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LPessoas);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Helper_Todos_Post;
var LTodos: TTodos; LResponse: IResponse;
begin
  LTodos := Mock_Todos;
  try
    LResponse := BaseRequest
      .Resource('/with-helper/todos')
      .AddBody(TJson.ObjectToClearJsonString(LTodos))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LTodos);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Biblioteca_Post;
var LBiblioteca : TBiblioteca; LResponse: IResponse;
begin
  LBiblioteca := Mock_Biblioteca;
  try
    LResponse := BaseRequest
      .Resource('/with-lib/biblioteca')
      .AddBody(TJson.ObjectToClearJsonString(LBiblioteca))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LBiblioteca);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Empresa_Post;
var LEmpresa : TEmpresa; LResponse: IResponse;
begin
  LEmpresa := Mock_Empresa;
  try
    LResponse := BaseRequest
      .Resource('/with-lib/empresa')
      .AddBody(TJson.ObjectToClearJsonString(LEmpresa))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LEmpresa);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Escola_Post;
var LEscola: TEscola; LResponse: IResponse;
begin
  LEscola := Mock_Escola;
  try
    LResponse := BaseRequest
      .Resource('/with-lib/escola')
      .AddBody(TJson.ObjectToClearJsonString(LEscola))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LEscola);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Familia_Post;
var LFamilia : TFamilia; LResponse: IResponse;
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

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Garagem_Post;
var LGaragem: TGaragem; LResponse: IResponse;
begin
  LGaragem := Mock_Garagem;
  try
    LResponse := BaseRequest
      .Resource('/with-lib/garagem')
      .AddBody(TJson.ObjectToClearJsonString(LGaragem))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LGaragem);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Pessoas_Post;
var LPessoas: TPessoas; LResponse: IResponse;
begin
  LPessoas := Mock_Pessoas;
  try
    LResponse := BaseRequest
      .Resource('/with-lib/pessoas')
      .AddBody(TJson.ObjectToClearJsonString(LPessoas))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LPessoas);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Lib_Todos_Post;
var LTodos: TTodos; LResponse: IResponse;
begin
  LTodos := Mock_Todos;
  try
    LResponse := BaseRequest
      .Resource('/with-lib/todos')
      .AddBody(TJson.ObjectToClearJsonString(LTodos))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LTodos);
  end;
end;


procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Biblioteca_Post;
var LBiblioteca : TBiblioteca; LResponse: IResponse;
begin
  LBiblioteca := Mock_Biblioteca;
  try
    LResponse := BaseRequest
      .Resource('/with-middleware/biblioteca')
      .AddBody(TJson.ObjectToClearJsonString(LBiblioteca))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LBiblioteca);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Empresa_Post;
var LEmpresa : TEmpresa; LResponse: IResponse;
begin
  LEmpresa := Mock_Empresa;
  try
    LResponse := BaseRequest
      .Resource('/with-middleware/empresa')
      .AddBody(TJson.ObjectToClearJsonString(LEmpresa))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LEmpresa);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Escola_Post;
var LEscola: TEscola; LResponse: IResponse;
begin
  LEscola := Mock_Escola;
  try
    LResponse := BaseRequest
      .Resource('/with-middleware/escola')
      .AddBody(TJson.ObjectToClearJsonString(LEscola))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LEscola);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Familia_Post;
var LFamilia : TFamilia; LResponse: IResponse;
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

procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Garagem_Post;
var LGaragem: TGaragem; LResponse: IResponse;
begin
  LGaragem := Mock_Garagem;
  try
    LResponse := BaseRequest
      .Resource('/with-middleware/garagem')
      .AddBody(TJson.ObjectToClearJsonString(LGaragem))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LGaragem);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Pessoas_Post;
var LPessoas: TPessoas; LResponse: IResponse;
begin
  LPessoas := Mock_Pessoas;
  try
    LResponse := BaseRequest
      .Resource('/with-middleware/pessoas')
      .AddBody(TJson.ObjectToClearJsonString(LPessoas))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LPessoas);
  end;
end;

procedure TestTHorseJsonInterceptorAPI.Test_Middleware_Todos_Post;
var LTodos: TTodos; LResponse: IResponse;
begin
  LTodos := Mock_Todos;
  try
    LResponse := BaseRequest
      .Resource('/with-middleware/todos')
      .AddBody(TJson.ObjectToClearJsonString(LTodos))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
    Assert.IsTrue(Pos('listHelper', LResponse.Content)=0, 'Esperava-se que não contivesse ListHelper');

  finally
    FreeAndNil(LTodos);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTHorseJsonInterceptorAPI);

end.
