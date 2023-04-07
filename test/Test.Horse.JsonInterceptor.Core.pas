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
  end;

implementation

uses
  Test.Mock.Horse.JsonInterceptor.Core,
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
    // Modelo padr�o, ir� gerar com ListHelper
    try
      LJson := TJson.ObjectToJsonObject(LFamilia);
      WriteLn('Com ListHelper : ' + LJson.ToString);

      LJsonValue := LJson.GetValue('membros').FindValue('listHelper');
      Assert.IsTrue(LJsonValue <> nil, 'Esperava-se que fosse poss�vel encontrar ListHelper em MEMBROS');
      LJsonValue := TJSONObject(TJSONArray(LJsonValue).Items[0]).GetValue('filhos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue <> nil, 'Esperava-se que fosse poss�vel encontrar ListHelper em FILHOS');
    finally
      LJson.DisposeOf;
    end;

    WriteLn('');
    // Comprova��o de que a Lib remove o ListHelper
    try
      LJson := TJson.ObjectToClearJsonObject(LFamilia);
      WriteLn('Sem ListHelper: ' + LJson.ToString);

      LJsonValue := LJson.GetValue('membros').FindValue('listHelper');
      Assert.IsTrue(LJsonValue = nil, 'Esperava-se que N�O fosse poss�vel encontrar ListHelper em MEMBROS');
      LJsonValue := TJSONObject(TJSONArray(LJson.GetValue('membros')).Items[0]).GetValue('filhos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue = nil, 'Esperava-se que N�O fosse poss�vel encontrar ListHelper em FILHOS');
    finally
      LJson.DisposeOf;
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
    try
      LJson := TJson.ObjectToJsonObject(LEmpresa);
      WriteLn('ObjectToJsonObject : ' + LJson.ToString);

      LJsonValue := LJson.GetValue('departamentos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue <> nil, 'Esperava-se que fosse poss�vel encontrar ListHelper');
    finally
      LJson.DisposeOf;
    end;

    WriteLn('');

    try
      LJson := TJson.ObjectToClearJsonObject(LEmpresa);
      WriteLn('ObjectToClearJsonObject: ' + LJson.ToString);

      LJsonValue := LJson.GetValue('departamentos').FindValue('listHelper');
      Assert.IsTrue(LJsonValue = nil, 'Esperava-se que N�O fosse poss�vel encontrar ListHelper');
    finally
      LJson.DisposeOf;
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
    // Modelo padr�o, ir� gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LFamilia);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprova��o de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LFamilia);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que N�O contivesse ListHelper');

  finally
    FreeAndNil(LFamilia);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComArrayObjetosComArrayInteger;
var LEscola: TEscola; LJsonString: String;
begin
  try
    LEscola := Mock_Escola;

    // Modelo padr�o, ir� gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LEscola);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprova��o de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LEscola);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que N�O contivesse ListHelper');
  finally
    FreeAndNil(LEscola);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComArrayObjetosComArrayStrings;
var LBiblioteca: TBiblioteca; LJsonString: String;
begin
  try
    LBiblioteca := Mock_Biblioteca;

    // Modelo padr�o, ir� gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LBiblioteca);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprova��o de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LBiblioteca);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que N�O contivesse ListHelper');
  finally
    FreeAndNil(LBiblioteca);
  end;
end;

procedure TestTHorseJsonInterceptor.Test_CriaJsonStringSemListHelper_ObjetoComArray;
var
  LEmpresa: TEmpresa;
  LJsonString: String;
begin
  try
    LEmpresa := Mock_Empresa;
    // Modelo padr�o, ir� gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LEmpresa);
    WriteLn('ObjectToJsonObject : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprova��o de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LEmpresa);
    WriteLn('ObjectToClearJsonObject: ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que N�O contivesse ListHelper');

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
    // Modelo padr�o, ir� gerar com ListHelper
    LJsonString := TJson.ObjectToJsonString(LGaragem);
    WriteLn('Com ListHelper : ' + LJsonString);
    Assert.IsTrue(Pos('listHelper', LJsonString)>0, 'Esperava-se que contivesse ListHelper');

    WriteLn('');

    // Comprova��o de que a Lib remove o ListHelper
    LJsonString := TJson.ObjectToClearJsonString(LGaragem);
    WriteLn('Sem ListHelper: ' + LJsonString);
     Assert.IsTrue(Pos('listHelper', LJsonString)=0, 'Esperava-se que N�O contivesse ListHelper');

  finally
    FreeAndNil(LGaragem);
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

  LFamilia :=TJson.ClearJsonAndConvertToObject<TFamilia>(LJson);
  Assert.AreEqual(2, LFamilia.Membros.Count, 'Deveria conter 2 membros');
  Assert.AreEqual('John Doe',LFamilia.membros[0].Nome,
    'Esperava-se que o 1� membro da familia fosse John Doe');

  Assert.AreEqual(1, LFamilia.Membros[0].Filhos.Count, 'John Doe deveria ter 1 filho');
  Assert.AreEqual('John Doe Jr', LFamilia.membros[0].Filhos[0].Nome,
    'Esperava-se que o filho de John Doe fosse John Doe Jr');

  FreeAndNil(LFamilia);
  LJson.DisposeOf;
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonObjectSemListHelper_ObjetoComArray;
var LJsonString : String; LJson : TJSONObject; LEmpresa: TEmpresa;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "BDMG", '
  + '	"departamentos": [ '
  + '		{ '
  + '			"nome": "Ger�ncia", '
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

  LEmpresa := TJson.ClearJsonAndConvertToObject<TEmpresa>(LJson);
  Assert.AreEqual(3, LEmpresa.Departamentos.Count, 'Deveria conter 3 departamentos');
  Assert.AreEqual('Desenvolvimento', LEmpresa.Departamentos[1].Nome,
    'Esperava-se que o segundo departamento fosse Desenvolvimento');

  FreeAndNil(LEmpresa);
  LJson.DisposeOf;
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
  Assert.AreEqual(2, LFamilia.Membros.Count, 'Deveria conter 2 membros');
  Assert.AreEqual('John Doe', LFamilia.membros[0].Nome,
    'Esperava-se que o 1� membro da familia fosse John Doe');

  Assert.AreEqual(1, LFamilia.Membros[0].Filhos.Count, 'John Doe deveria ter 1 filho');
  Assert.AreEqual('John Doe Jr', LFamilia.membros[0].Filhos[0].Nome,
    'Esperava-se que o filho de John Doe fosse John Doe Jr');

  FreeAndNil(LFamilia);
end;

procedure TestTHorseJsonInterceptor.Test_CriarObjetoUtilizandoJsonStringSemListHelper_ObjetoComArray;
var LJsonString : String; LEmpresa: TEmpresa;
begin
  LJsonString := #13#10
  + '{ '
  + '	"nome": "BDMG", '
  + '	"departamentos": [ '
  + '		{ '
  + '			"nome": "Ger�ncia", '
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
  Assert.AreEqual(3, LEmpresa.Departamentos.Count, 'Deveria conter 3 departamentos');
  Assert.AreEqual('Desenvolvimento', LEmpresa.Departamentos[1].Nome,
    'Esperava-se que o segundo departamento fosse Desenvolvimento');

  FreeAndNil(LEmpresa);
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
  + '			"nome": "Voc�", '
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

  try
    LEscola := TJson.ClearJsonAndConvertToObject<TEscola>(LJsonString);
    Assert.AreEqual(3, LEscola.Alunos.Count, 'Deveria conter 3 alunos');
    Assert.AreEqual('Eu', LEscola.Alunos[0].Nome,
      'Esperava-se que o 1� aluno fosse Eu');
    Assert.AreEqual(4, Length(LEscola.Alunos[0].Notas),
      'Esperava-se que o aluno Eu tivesse 4 notas');
    Assert.AreEqual(30, LEscola.Alunos[0].Notas[2],
      'Esperava-se que o 3� nota do aluno Eu fosse 30');


    Assert.AreEqual('Voc�', LEscola.Alunos[1].Nome,
      'Esperava-se que o 1� aluno fosse Voc�');
    Assert.AreEqual(4, Length(LEscola.Alunos[1].Notas),
      'Esperava-se que o aluno Eu tivesse 4 notas');
    Assert.AreEqual(24, LEscola.Alunos[1].Notas[2],
      'Esperava-se que o 3� nota do aluno Voc� fosse 24');

    Assert.AreEqual('Ele', LEscola.Alunos[2].Nome,
      'Esperava-se que o 1� aluno fosse Ele');
    Assert.AreEqual(0, Length(LEscola.Alunos[2].Notas),
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
  + '			"nome": "Divina Com�dia", '
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
  try
    LBibioteca := TJson.ClearJsonAndConvertToObject<TBiblioteca>(LJsonString);
    Assert.AreEqual(3, LBibioteca.Livros.Count, 'Deveria conter 2 livros');
    Assert.AreEqual('Dom Quixote', LBibioteca.Livros[0].Nome,
      'Esperava-se que o 1� livro fosse Dom Quixote');
    Assert.AreEqual(2, Length(LBibioteca.Livros[0].Genero),
      'Esperava-se que o 1� livro possuisse 2 g�neros');
    Assert.AreEqual('Fantasia', LBibioteca.Livros[0].Genero[0],
      'Esperava-se que o 1� g�nero do 1� livro fose Fantasia');


    Assert.AreEqual('Divina Com�dia', LBibioteca.Livros[1].Nome,
      'Esperava-se que o 2� livro fosse Divina Com�dia');
    Assert.AreEqual(2, Length(LBibioteca.Livros[1].Genero),
      'Esperava-se que o 2� livro possuisse 2 g�neros');
    Assert.AreEqual('Aventura', LBibioteca.Livros[1].Genero[0],
      'Esperava-se que o 1� g�nero do 2� livro fose Aventura');

    Assert.AreEqual('Outro Livro', LBibioteca.Livros[2].Nome,
      'Esperava-se que o 3� livro fosse Divina Com�dia');
    Assert.AreEqual(0, Length(LBibioteca.Livros[2].Genero),
      'Esperava-se que o 3� livro possuisse 0 g�neros');

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
  + '				"nome": "Voc�", '
  + '				"codigo": 3, '
  + '				"sexo": "F", '
  + '				"filhos": [] '
  + '			} '
  + '		] '
  + '	} '
  + '} '
  ;

  LGaragem := TJson.ClearJsonAndConvertToObject<TGaragem>(LJsonString);
  Assert.AreEqual(2, LGaragem.Carro.Ocupantes.Count, 'Deveria conter 2 ocupantes');
  Assert.AreEqual('Eu', LGaragem.Carro.Ocupantes[0].Nome,
    'Esperava-se que o Eu estivesse no carro');
  Assert.AreEqual('Voc�', LGaragem.Carro.Ocupantes[1].Nome,
    'Esperava-se que o Voc� estivesse no carro');
  FreeAndNil(LGaragem);
end;

initialization
  TDUnitX.RegisterTestFixture(TestTHorseJsonInterceptor);

end.
