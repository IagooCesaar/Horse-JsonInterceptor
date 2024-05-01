unit Test.Horse.JsonInterceptor.Core;

interface

uses
  DUnitX.TestFramework,
  Horse.JsonInterceptor.Helpers;

type
  [TestFixture]
  TestTHorseJsonInterceptor = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    // TEmpresa : { departamentos: [ { departamento } ] }
    [Test]
    procedure Test_CriaJsonObjectSemListHelper_ObjetoComArray;

    [Test]
    procedure Test_CriaJsonStringSemListHelper_ObjetoComArray;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArray;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonObjectSemListHelper_ObjetoComArray;


    // TFamilia : { membros: [ { pessoa.filhos[ { pessoa.filhos[] } ] } ] }
    [Test]
    procedure Test_CriaJsonObjectSemListHelper_ObjetoComArrayRecursivo;

    [Test]
    procedure Test_CriaJsonStringSemListHelper_ObjetoComArrayRecursivo;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArrayRecursivo;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonObjectSemListHelper_ObjetoComArrayRecursivo;


    // TGaragem : { carro: { ocupantes: [ pessoa ] } }
    [Test]
    procedure Test_CriaJsonStringSemListHelper_ObjetoComObjetoComArray;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComObjetoComArray;

    // TBiblioteca : { livros: [ generos: [string] ] }
    [Test]
    procedure Test_CriaJsonStringSemListHelper_ObjetoComArrayObjetosComArrayStrings;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArrayObjetosComArrayStrings;

    // TEscola : { alunos: [ notas: [integer] ] }
    [Test]
    procedure Test_CriaJsonStringSemListHelper_ObjetoComArrayObjetosComArrayInteger;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArrayObjetosComArrayInteger;

    // TPessoas: [ pessoa ]
    [Test]
    procedure Test_CriaJsonStringSemListHelper_ArrayComObjetosComArray;

    [Test]
    procedure Test_CriaJsonStringSemListHelper_ArrayComObjetosComArray_Vazio;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonStringSemListHelper_ArrayComObjetosComArray;

    [Test]
    procedure Test_CriarObjetoUtilizandoJsonStringSemListHelper_ArrayComObjetosComArray_Vazio;

    // TMusica: { musica }
    [Test]
    procedure Test_CriarObjetoComValidacao;

    [Test]
    procedure Test_NaoCriarObjetoComValidacao_PropriedadeIncorreta;

    [Test]
    procedure Test_NaoCriarObjetoComValidacao_PropriedadeOmitida;

    [Test]
    procedure Test_CriarObjetoComValidacao_2;

    [Test]
    procedure Test_NaoCriarObjetoComValidacao_PropriedadeIncorreta_2;

    [Test]
    procedure Test_NaoCriarObjetoComValidacao_PropriedadeOmitida_2;

    // Todas as classes acima
    [Test]
    procedure Test_CriaJsonStringSemListHelper_Todos;
  end;

implementation

uses
  Horse.JsonInterceptor.Example.Classes,
  System.JSON,
  System.SysUtils;

procedure TestTHorseJsonInterceptor.Setup;
begin
end;

procedure TestTHorseJsonInterceptor.TearDown;
begin
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonObjectSemListHelper_ObjetoComArrayRecursivo;
var
  LFamilia: TFamilia;
  LJson: TJSONObject;
  LJsonValue: TJSONValue;
  LJsonString: String;
begin
  try
    LFamilia := Mock_Familia;

    // Modelo padrão, irá gerar com ListHelper
    LJson := TJson.ObjectToJsonObject(LFamilia);
    try
      WriteLn('Com ListHelper : ' + LJson.ToString);

      LJsonValue := LJson.GetValue('membros').FindValue('listHelper');
      Assert.IsTrue(LJsonValue <> nil, 'Esperava-se que fosse possível encontrar ListHelper em MEMBROS');
      LJsonValue := TJSONObject(TJSONArray(LJsonValue).Items[0]).GetValue('filhos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue <> nil, 'Esperava-se que fosse possível encontrar ListHelper em FILHOS');
    finally
      LJson.Free;
    end;

    WriteLn('');
    // Comprovação de que a Lib remove o ListHelper
    LJson := TJson.ObjectToClearJsonObject(LFamilia);
    try
      WriteLn('Sem ListHelper: ' + LJson.ToString);

      LJsonValue := LJson.GetValue('membros').FindValue('listHelper');
      Assert.IsTrue(LJsonValue = nil, 'Esperava-se que NÃO fosse possível encontrar ListHelper em MEMBROS');
      LJsonValue := TJSONObject(TJSONArray(LJson.GetValue('membros')).Items[0]).GetValue('filhos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue = nil, 'Esperava-se que NÃO fosse possível encontrar ListHelper em FILHOS');
    finally
      LJson.Free;
    end;
  finally
    FreeAndNil(LFamilia);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonObjectSemListHelper_ObjetoComArray;
var
  LEmpresa: TEmpresa;
  LJson: TJSONObject;
  LJsonValue: TJSONValue;
  LJsonString: String;
begin
  try
    LEmpresa := Mock_Empresa;

    LJson := TJson.ObjectToJsonObject(LEmpresa);
    try
      WriteLn('Com ListHelper: ' + LJson.ToString);

      LJsonValue := LJson.GetValue('departamentos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue <> nil, 'Esperava-se que fosse possível encontrar ListHelper');
    finally
      LJson.Free;
    end;

    WriteLn('');

    LJson := TJson.ObjectToClearJsonObject(LEmpresa);
    try
      WriteLn('Sem ListHelper: ' + LJson.ToString);

      LJsonValue := LJson.GetValue('departamentos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue = nil, 'Esperava-se que NÃO fosse possível encontrar ListHelper');
    finally
      LJson.Free;
    end;

  finally
    FreeAndNil(LEmpresa);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComArrayRecursivo;
var
  LFamilia: TFamilia;
  LJsonString: String;
begin
  try
    LFamilia := Mock_Familia;
    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LFamilia);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LFamilia);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');

  finally
    FreeAndNil(LFamilia);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComArrayObjetosComArrayInteger;
var LEscola: TEscola; LJsonString: String;
begin
  try
    LEscola := Mock_Escola;

    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LEscola);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LEscola);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');
  finally
    FreeAndNil(LEscola);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComArrayObjetosComArrayStrings;
var LBiblioteca: TBiblioteca; LJsonString: String;
begin
  try
    LBiblioteca := Mock_Biblioteca;

    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LBiblioteca);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LBiblioteca);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');
  finally
    FreeAndNil(LBiblioteca);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ArrayComObjetosComArray;
var LPessoas: TPessoas; LJsonString: String;
begin
  try
    LPessoas := Mock_Pessoas;
    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LPessoas);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LPessoas);
    WriteLn('Sem ListHelper: ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');

  finally
    FreeAndNil(LPessoas);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ArrayComObjetosComArray_Vazio;
var LPessoas: TPessoas; LJsonString: String;
begin
  try
    LPessoas := TPessoas.Create;
    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LPessoas);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LPessoas);
    WriteLn('Sem ListHelper: ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');

  finally
    FreeAndNil(LPessoas);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComArray;
var
  LEmpresa: TEmpresa;
  LJsonString: String;
begin
  try
    LEmpresa := Mock_Empresa;
    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LEmpresa);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LEmpresa);
    WriteLn('Sem ListHelper: ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');

  finally
    FreeAndNil(LEmpresa);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComObjetoComArray;
var
  LGaragem: TGaragem;
  LJsonString: String;
begin
  try
    LGaragem := Mock_Garagem;
    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LGaragem);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LGaragem);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');

  finally
    FreeAndNil(LGaragem);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_Todos;
var LTodos: TTodos; LJsonString: String;
begin
  try
    LTodos := Mock_Todos;
    // Modelo padrão, irá gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LTodos);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprovação de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LTodos);
    WriteLn('Sem ListHelper: ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que NÃO contivesse ListHelper');

  finally
    FreeAndNil(LTodos);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonObjectSemListHelper_ObjetoComArrayRecursivo;
var LJsonString: String; LJson: TJSONObject; LFamilia: TFamilia;
begin
  LJsonString := #13#10
  + '{ '
  + '	"membros": [ '
  + '		{ '
  + '			"nome": "John Doe", '
  + '			"codigo": 10, '
  + '			"sexo": "Male", '
  + '			"filhos": [ '
  + '				{ '
  + '					"nome": "John Doe Jr", '
  + '					"codigo": 30, '
  + '					"sexo": "Male", '
  + '					"filhos": [ '
  + '						{ '
  + '							"nome": "John Doe Third", '
  + '							"codigo": 40, '
  + '							"sexo": "Male", '
  + '							"filhos": [] '
  + '						} '
  + '					] '
  + '				} '
  + '			] '
  + '		}, '
  + '		{ '
  + '			"nome": "Jane Doe", '
  + '			"codigo": 20, '
  + '			"sexo": "Female", '
  + '			"filhos": [ '
  + '				{ '
  + '					"nome": "John Doe Jr", '
  + '					"codigo": 30, '
  + '					"sexo": "Male", '
  + '					"filhos": [ '
  + '						{ '
  + '							"nome": "John Doe Third", '
  + '							"codigo": 40, '
  + '							"sexo": "Male", '
  + '							"filhos": [] '
  + '						} '
  + '					] '
  + '				} '
  + '			] '
  + '		} '
  + '	] '
  + '} '
  ;

  LJson := TJSONObject.ParseJSONValue(LJsonString) as TJSONObject;
  try
    LFamilia :=TJson.ClearJsonAndConvertToObject<TFamilia>(LJson);
    Assert.AreEqual(NativeInt(2), LFamilia.Membros.Count, 'Deveria conter 2 membros');
    Assert.AreEqual('John Doe',LFamilia.membros[0].Nome,
      'Esperava-se que o 1º membro da familia fosse John Doe');

    Assert.AreEqual(NativeInt(1), LFamilia.Membros[0].Filhos.Count, 'John Doe deveria ter 1 filho');
    Assert.AreEqual('John Doe Jr', LFamilia.membros[0].Filhos[0].Nome,
      'Esperava-se que o filho de John Doe fosse John Doe Jr');

  finally
    FreeAndNil(LFamilia);
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoComValidacao;
var LJsonString: string; LJson : TJSONObject; LMusica, LMusicaValidado: TMusica;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Simple Man", '
  + '	"album": "(Pronounced ''Leh-''nérd ''Skin-''nérd)", '
  + '	"artista": "Lynyrd Skynyrd", '
  + '	"tempo": "00:06:00" '
  + '} '
  ;

  LJson := TJSONObject.ParseJSONValue(LJsonString) as TJSONObject;
  try
    LMusica := TJson.ClearJsonAndConvertToObject<TMusica>(LJson);
    Assert.AreEqual('Simple Man', LMusica.Nome);
    Assert.AreEqual('00:06:00', LMusica.Tempo);

    LMusicaValidado := TJson.RevalidateSetters<TMusica>(LMusica);
    LMusicaValidado.Free;
  finally
    FreeAndNil(LMusica);
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoComValidacao_2;
var LJsonString: string; LJson: TJSONValue; LMusica: TMusica;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Simple Man", '
  + '	"album": "(Pronounced ''Leh-''nérd ''Skin-''nérd)", '
  + '	"artista": "Lynyrd Skynyrd", '
  + '	"tempo": "00:06:00" '
  + '} '
  ;
  LJson := TJSONObject.ParseJSONValue(LJsonString);
  try
    LMusica := TJson.ClearJsonAndConvertToObject<TMusica>(LJson,
      TJson.CDefaultOptions, [joRevalidateSetters]);

    Assert.AreEqual('Simple Man', LMusica.Nome);
    Assert.AreEqual('00:06:00', LMusica.Tempo);
  finally
    FreeAndNil(LMusica);
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_NaoCriarObjetoComValidacao_PropriedadeIncorreta;
var LJsonString: string; LJson : TJSONObject; LMusica: TMusica;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Nome da música", '
  + '	"album": "Nome do álbum", '
  + '	"artista": "Nome do artista", '
  + '	"tempo": "00:00" '
  + '} '
  ;

  LJson := TJSONObject.ParseJSONValue(LJsonString) as TJSONObject;
  try
    LMusica := TJson.ClearJsonAndConvertToObject<TMusica>(LJson);
    // Neste ponto não passa pela validação no método Set
    Assert.AreEqual('Nome da Música', LMusica.Nome);
    Assert.AreEqual('00:00:00', LMusica.Tempo);

    Assert.WillRaiseWithMessage((
      procedure begin
        TJson.RevalidateSetters<TMusica>(LMusica);
      end),
      Exception,
      'O Tempo de execução deverá ser superior a "00:00"'
    );
  finally
    FreeAndNil(LMusica);
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_NaoCriarObjetoComValidacao_PropriedadeIncorreta_2;
var LJsonString: string; LJson : TJSONValue;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Nome da música", '
  + '	"album": "Nome do álbum", '
  + '	"artista": "Nome do artista", '
  + '	"tempo": "00:00" '
  + '} '
  ;

  LJson := TJSONObject.ParseJSONValue(LJsonString);
  try
    Assert.WillRaiseWithMessage((
      procedure begin
        TJson.ClearJsonAndConvertToObject<TMusica>(LJson,
          TJson.CDefaultOptions, [joRevalidateSetters]);
      end),
      Exception,
      'O Tempo de execução deverá ser superior a "00:00"'
    );
  finally
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_NaoCriarObjetoComValidacao_PropriedadeOmitida;
var LJsonString: string; LJson : TJSONObject; LMusica: TMusica;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Nome da música", '
  + '	"album": "Nome do álbum", '
  + '	"tempo": "0:06:00" '
  + '} '
  ;

  LJson := TJSONObject.ParseJSONValue(LJsonString) as TJSONObject;
  try
    LMusica := TJson.ClearJsonAndConvertToObject<TMusica>(LJson);
    // Neste ponto não passa pela validação no método Set
    Assert.AreEqual('Nome da Música', LMusica.Nome);
    Assert.AreEqual('00:06:00', LMusica.Tempo);

    Assert.WillRaiseWithMessageRegex((
      procedure begin
        TJson.RevalidateSetters<TMusica>(LMusica);
      end),
      Exception,
      'O Nome do Artista deverá ter no mínimo'
    );
  finally
    FreeAndNil(LMusica);
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_NaoCriarObjetoComValidacao_PropriedadeOmitida_2;
var LJsonString: string; LJson : TJSONValue;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "Nome da música", '
  + '	"album": "Nome do álbum", '
  + '	"tempo": "0:06:00" '
  + '} '
  ;
  LJson := TJSONObject.ParseJSONValue(LJsonString);
  try
    Assert.WillRaiseWithMessageRegex((
      procedure begin
        TJson.ClearJsonAndConvertToObject<TMusica>(LJson,
          TJson.CDefaultOptions, [joRevalidateSetters]);
      end),
      Exception,
      'O Nome do Artista deverá ter no mínimo'
    );
  finally
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonObjectSemListHelper_ObjetoComArray;
var LJsonString : String; LJson : TJSONObject; LEmpresa: TEmpresa;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "BDMG", '
  + '	"departamentos": [ '
  + '		{ '
  + '			"nome": "Gerência", '
  + '			"area": "TI" '
  + '		}, '
  + '		{ '
  + '			"nome": "Desenvolvimento", '
  + '			"area": "TI" '
  + '		}, '
  + '		{ '
  + '			"nome": "Infraestrutura", '
  + '			"area": "TI" '
  + '		} '
  + '	] '
  + '} '
  ;

  LJson := TJSONObject.ParseJSONValue(LJsonString) as TJSONObject;
  try
    LEmpresa := TJson.ClearJsonAndConvertToObject<TEmpresa>(LJson);
    Assert.AreEqual(NativeInt(3), LEmpresa.Departamentos.Count, 'Deveria conter 3 departamentos');
    Assert.AreEqual('Desenvolvimento', LEmpresa.Departamentos[1].Nome,
      'Esperava-se que o segundo departamento fosse Desenvolvimento');
  finally
    FreeAndNil(LEmpresa);
    LJson.Free;
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArrayRecursivo;
var LJsonString: String; LFamilia: TFamilia;
begin
  LJsonString := #13#10
  + '{ '
  + '	"membros": [ '
  + '		{ '
  + '			"nome": "John Doe", '
  + '			"codigo": 10, '
  + '			"sexo": "Male", '
  + '			"filhos": [ '
  + '				{ '
  + '					"nome": "John Doe Jr", '
  + '					"codigo": 30, '
  + '					"sexo": "Male", '
  + '					"filhos": [ '
  + '						{ '
  + '							"nome": "John Doe Third", '
  + '							"codigo": 40, '
  + '							"sexo": "Male", '
  + '							"filhos": [] '
  + '						} '
  + '					] '
  + '				} '
  + '			] '
  + '		}, '
  + '		{ '
  + '			"nome": "Jane Doe", '
  + '			"codigo": 20, '
  + '			"sexo": "Female", '
  + '			"filhos": [ '
  + '				{ '
  + '					"nome": "John Doe Jr", '
  + '					"codigo": 30, '
  + '					"sexo": "Male", '
  + '					"filhos": [ '
  + '						{ '
  + '							"nome": "John Doe Third", '
  + '							"codigo": 40, '
  + '							"sexo": "Male", '
  + '							"filhos": [] '
  + '						} '
  + '					] '
  + '				} '
  + '			] '
  + '		} '
  + '	] '
  + '} '
  ;

  LFamilia := TJson.ClearJsonAndConvertToObject<TFamilia>(LJsonString);
  try
    Assert.AreEqual(NativeInt(2), LFamilia.Membros.Count, 'Deveria conter 2 membros');
    Assert.AreEqual('John Doe', LFamilia.membros[0].Nome,
      'Esperava-se que o 1º membro da familia fosse John Doe');

    Assert.AreEqual(NativeInt(1), LFamilia.Membros[0].Filhos.Count, 'John Doe deveria ter 1 filho');
    Assert.AreEqual('John Doe Jr', LFamilia.membros[0].Filhos[0].Nome,
      'Esperava-se que o filho de John Doe fosse John Doe Jr');
  finally
    FreeAndNil(LFamilia);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ArrayComObjetosComArray;
var LJsonString: String; LPessoas: TPessoas;
begin
  LJsonString := #13#10
  + '[ '
  + '	{ '
  + '		"nome": "Eu", '
  + '		"codigo": 10, '
  + '		"sexo": "M", '
  + '		"filhos": [] '
  + '	}, '
  + '	{ '
  + '		"nome": "Você", '
  + '		"codigo": 20, '
  + '		"sexo": "F", '
  + '		"filhos": [] '
  + '	} '
  + '] '
  ;

  LPessoas := TJson.ClearJsonAndConvertToObject<TPessoas>(LJsonString);
  try
    Assert.AreEqual(NativeInt(2), LPessoas.Count, 'Deveria conter 2 alunos');
    Assert.AreEqual('Eu', LPessoas[0].Nome,
      'Esperava-se que a 1ª pessoa fosse Eu');
    Assert.AreEqual('Você', LPessoas[1].Nome,
      'Esperava-se que o 1º aluno fosse Você');
  finally
    FreeAndNil(LPessoas);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ArrayComObjetosComArray_Vazio;
var LJsonString: String; LPessoas: TPessoas;
begin
  LJsonString := #13#10 + '[ ] ';

  LPessoas := TJson.ClearJsonAndConvertToObject<TPessoas>(LJsonString);
  try
    Assert.AreEqual(NativeInt(0), LPessoas.Count, 'Não deveria conter alunos');
  finally
    FreeAndNil(LPessoas);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArray;
var LJsonString : String; LEmpresa: TEmpresa;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "BDMG", '
  + '	"departamentos": [ '
  + '		{ '
  + '			"nome": "Gerência", '
  + '			"area": "TI" '
  + '		}, '
  + '		{ '
  + '			"nome": "Desenvolvimento", '
  + '			"area": "TI" '
  + '		}, '
  + '		{ '
  + '			"nome": "Infraestrutura", '
  + '			"area": "TI" '
  + '		} '
  + '	] '
  + '} '
  ;

  LEmpresa := TJson.ClearJsonAndConvertToObject<TEmpresa>(LJsonString);
  try
    Assert.AreEqual(NativeInt(3), LEmpresa.Departamentos.Count, 'Deveria conter 3 departamentos');
    Assert.AreEqual('Desenvolvimento', LEmpresa.Departamentos[1].Nome,
      'Esperava-se que o segundo departamento fosse Desenvolvimento');
  finally
    FreeAndNil(LEmpresa);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArrayObjetosComArrayInteger;
var LJsonString: String; LEscola: TEscola;
begin
  LJsonString := #13#10
  + '{ '
  + '	"alunos": [ '
  + '		{ '
  + '			"nome": "Eu", '
  + '			"notas": [ '
  + '				10, '
  + '				20, '
  + '				30, '
  + '				40 '
  + '			] '
  + '		}, '
  + '		{ '
  + '			"nome": "Você", '
  + '			"notas": [ '
  + '				6, '
  + '				12, '
  + '				24, '
  + '				36 '
  + '			] '
  + '		}, '
  + '		{ '
  + '			"nome": "Ele", '
  + '			"notas": [] '
  + '		} '
  + '	] '
  + '} '
  ;

  LEscola := TJson.ClearJsonAndConvertToObject<TEscola>(LJsonString);
  try
    Assert.AreEqual(NativeInt(3), LEscola.Alunos.Count, 'Deveria conter 3 alunos');
    Assert.AreEqual('Eu', LEscola.Alunos[0].Nome,
      'Esperava-se que o 1º aluno fosse Eu');
    Assert.AreEqual(NativeInt(4), Length(LEscola.Alunos[0].Notas),
      'Esperava-se que o aluno Eu tivesse 4 notas');
    Assert.AreEqual(30, LEscola.Alunos[0].Notas[2],
      'Esperava-se que o 3ª nota do aluno Eu fosse 30');


    Assert.AreEqual('Você', LEscola.Alunos[1].Nome,
      'Esperava-se que o 1º aluno fosse Você');
    Assert.AreEqual(NativeInt(4), Length(LEscola.Alunos[1].Notas),
      'Esperava-se que o aluno Eu tivesse 4 notas');
    Assert.AreEqual(24, LEscola.Alunos[1].Notas[2],
      'Esperava-se que o 3ª nota do aluno VocÊ fosse 24');

    Assert.AreEqual('Ele', LEscola.Alunos[2].Nome,
      'Esperava-se que o 1º aluno fosse Ele');
    Assert.AreEqual(NativeInt(0), Length(LEscola.Alunos[2].Notas),
      'Esperava-se que o aluno Ele tivesse 0 notas');


  finally
    FreeAndNil(LEscola);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArrayObjetosComArrayStrings;
var LJsonString: String; LBibioteca: TBiblioteca;
begin
  LJsonString := #13#10
  + '{ '
  + '	"livros": [ '
  + '		{ '
  + '			"nome": "Dom Quixote", '
  + '			"autor": "Miguel Cercantes", '
  + '			"edicao": 1, '
  + '			"genero": [ '
  + '				"Fantasia", '
  + '				"Aventura" '
  + '			] '
  + '		}, '
  + '		{ '
  + '			"nome": "Divina Comédia", '
  + '			"autor": "Dante Alighieri", '
  + '			"edicao": 1, '
  + '			"genero": [ '
  + '				"Aventura", '
  + '				"Fantasia" '
  + '			] '
  + '		}, '
  + '		{ '
  + '			"nome": "Outro Livro", '
  + '			"autor": "Outro autor", '
  + '			"edicao": 100, '
  + '			"genero": [] '
  + '		} '
  + '	] '
  + '} '
  ;

  LBibioteca := TJson.ClearJsonAndConvertToObject<TBiblioteca>(LJsonString);
  try
    Assert.AreEqual(NativeInt(3), LBibioteca.Livros.Count, 'Deveria conter 2 livros');
    Assert.AreEqual('Dom Quixote', LBibioteca.Livros[0].Nome,
      'Esperava-se que o 1º livro fosse Dom Quixote');
    Assert.AreEqual(NativeInt(2), Length(LBibioteca.Livros[0].Genero),
      'Esperava-se que o 1º livro possuisse 2 gêneros');
    Assert.AreEqual('Fantasia', LBibioteca.Livros[0].Genero[0],
      'Esperava-se que o 1º gênero do 1º livro fose Fantasia');


    Assert.AreEqual('Divina Comédia', LBibioteca.Livros[1].Nome,
      'Esperava-se que o 2º livro fosse Divina Comédia');
    Assert.AreEqual(NativeInt(2), Length(LBibioteca.Livros[1].Genero),
      'Esperava-se que o 2º livro possuisse 2 gêneros');
    Assert.AreEqual('Aventura', LBibioteca.Livros[1].Genero[0],
      'Esperava-se que o 1º gênero do 2º livro fose Aventura');

    Assert.AreEqual('Outro Livro', LBibioteca.Livros[2].Nome,
      'Esperava-se que o 3º livro fosse Divina Comédia');
    Assert.AreEqual(NativeInt(0), Length(LBibioteca.Livros[2].Genero),
      'Esperava-se que o 3º livro possuisse 0 gêneros');

  finally
    FreeAndNil(LBibioteca);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComObjetoComArray;
var LJsonString: String; LGaragem: TGaragem;
begin
  LJsonString := #13#10
  + '{ '
  + '	"carro": { '
  + '		"ocupantes": [ '
  + '			{ '
  + '				"nome": "Eu", '
  + '				"codigo": 2, '
  + '				"sexo": "M", '
  + '				"filhos": [] '
  + '			}, '
  + '			{ '
  + '				"nome": "Você", '
  + '				"codigo": 3, '
  + '				"sexo": "F", '
  + '				"filhos": [] '
  + '			} '
  + '		] '
  + '	} '
  + '} '
  ;

  LGaragem := TJson.ClearJsonAndConvertToObject<TGaragem>(LJsonString);
  try
    Assert.AreEqual(NativeInt(2), LGaragem.Carro.Ocupantes.Count, 'Deveria conter 2 ocupantes');
    Assert.AreEqual('Eu', LGaragem.Carro.Ocupantes[0].Nome,
      'Esperava-se que o Eu estivesse no carro');
    Assert.AreEqual('Você', LGaragem.Carro.Ocupantes[1].Nome,
      'Esperava-se que o Você estivesse no carro');
  finally
    FreeAndNil(LGaragem);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTHorseJsonInterceptor);

end.
