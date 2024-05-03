unit Horse.JsonInterceptor.Example.Classes;

interface

uses
  System.Generics.Collections;

type
  TPessoa = class
  private
    FNome: string;
    FCodigo: Integer;
    FSexo: string;
    FFilhos: TObjectList<TPessoa>;
  public
    property Nome: string read FNome write FNome;
    property Codigo: Integer read FCodigo write FCodigo;
    property Sexo: string read FSexo write FSexo;
    property Filhos: TObjectList<TPessoa> read FFilhos write FFilhos;

    constructor Create;
    destructor Destroy; override;
  end;

  TFamilia = class
  private
    FMembros: TObjectList<TPessoa>;
  public
    property Membros: TObjectList<TPessoa> read FMembros write FMembros;

    constructor Create;
    destructor Destroy; override;
  end;

  TLivro = class
  private
    FNome: string;
    FAutor: String;
    FEdicao: Integer;
  public
    Genero: TArray<string>;

    property Nome: string read FNome write FNome;
    property Autor: String read FAutor write FAutor;
    property Edicao: Integer read FEdicao write FEdicao;
  end;

  TBiblioteca = class
  private
    FLivros: TObjectList<TLivro>;
  public
    property Livros: TObjectList<TLivro> read FLivros write FLivros;
    constructor Create;
    destructor Destroy; override;
  end;

  TDepartamento = class
  private
    FNome: String;
    FArea: string;
  public
    property Nome: String read FNome write FNome;
    property Area: string read FArea write FArea;
    constructor Create;
    destructor Destroy; override;
  end;

  TEmpresa = class
  private
    FNome: String;
    FDepartamentos: TObjectList<TDepartamento>;
  public
    property Nome: String read FNome write FNome;
    property Departamentos: TObjectList<TDepartamento> read FDepartamentos write FDepartamentos;

    constructor Create;
    destructor Destroy; override;
  end;

  TCarro = class
  private
    FOcupantes: TObjectList<TPessoa>;
  public
    property Ocupantes: TObjectList<TPessoa> read FOcupantes write FOcupantes;

    constructor Create;
    destructor Destroy; override;
  end;

  TGaragem = class
  private
    FCarro: TCarro;
  public
    property Carro: TCarro read FCarro write FCarro;

    constructor Create;
    destructor Destroy; override;
  end;

  TAluno = class
  private
    FNome: string;
  public
    Notas: TArray<Integer>;
    property Nome: string read FNome write FNome;
  end;

  TEscola = class
  private
    FAlunos: TObjectList<TAluno>;
  public
    property Alunos: TObjectList<TAluno> read FAlunos write FAlunos;

    constructor Create;
    destructor Destroy; override;
  end;

  TPessoas = TObjectList<TPessoa>;

  TMusica = class
  private
    FNome: string;
    FArtista: string;
    FAlbum: string;
    FTempo: string;

    function GetNome: string;
    procedure SetNome(const Value: string);
    function GetArtista: string;
    procedure SetArtista(const Value: string);
    function GetAlbum: string;
    procedure SetAlbum(const Value: string);
    function GetTempo: string;
    procedure SetTempo(const Value: string);
  public
    property Nome: string read GetNome write SetNome;
    property Artista: string read GetArtista write SetArtista;
    property Album: string read GetAlbum write SetAlbum;
    property Tempo: string read GetTempo write SetTempo;
  end;

  TTodos = class
  private
    FFamilia: TFamilia;
    FBiblioteca: TBiblioteca;
    FEmpresa: TEmpresa;
    FGaragem: TGaragem;
    FEscola: TEscola;
    FPessoas: TPessoas;
  public
    property Familia: TFamilia read FFamilia write FFamilia;
    property Biblioteca: TBiblioteca read FBiblioteca write FBiblioteca;
    property Empresa: TEmpresa read FEmpresa write FEmpresa;
    property Garagem: TGaragem read FGaragem write FGaragem;
    property Escola: TEscola read FEscola write FEscola;
    property Pessoas: TPessoas read FPessoas write FPessoas;

    constructor Create;
    destructor Destroy; override;
  end;

function Mock_Familia: TFamilia;
function Mock_Biblioteca: TBiblioteca;
function Mock_Empresa: TEmpresa;
function Mock_Garagem: TGaragem;
function Mock_Escola: TEscola;
function Mock_Pessoas: TPessoas;
function Mock_Musica: TMusica;
function Mock_Todos: TTodos;

implementation

uses
  System.SysUtils;

function Mock_Familia: TFamilia;
begin
  Result := TFamilia.Create;

  Result.Membros.Add(TPessoa.Create);
  Result.Membros.Last.Codigo  := 10;
  Result.Membros.Last.Nome    := 'John Doe';
  Result.Membros.Last.Sexo    := 'Male';
  Result.Membros.Last.Filhos.Add(TPessoa.Create);
  Result.Membros.Last.Filhos.Last.Codigo  := 30;
  Result.Membros.Last.Filhos.Last.Nome    := 'John Doe Jr';
  Result.Membros.Last.Filhos.Last.Sexo    := 'Male';
  Result.Membros.Last.Filhos.Last.Filhos.Add(TPessoa.Create);
  Result.Membros.Last.Filhos.Last.Filhos.Last.Codigo  := 40;
  Result.Membros.Last.Filhos.Last.Filhos.Last.Nome    := 'John Doe Third';
  Result.Membros.Last.Filhos.Last.Filhos.Last.Sexo    := 'Male';

  Result.Membros.Add(TPessoa.Create);
  Result.Membros.Last.Codigo  := 20;
  Result.Membros.Last.Nome    := 'Jane Doe';
  Result.Membros.Last.Sexo    := 'Female';
  Result.Membros.Last.Filhos.Add(TPessoa.Create);
  Result.Membros.Last.Filhos.Last.Codigo  := 30;
  Result.Membros.Last.Filhos.Last.Nome    := 'John Doe Jr';
  Result.Membros.Last.Filhos.Last.Sexo    := 'Male';
  Result.Membros.Last.Filhos.Last.Filhos.Add(TPessoa.Create);
  Result.Membros.Last.Filhos.Last.Filhos.Last.Codigo  := 40;
  Result.Membros.Last.Filhos.Last.Filhos.Last.Nome    := 'John Doe Third';
  Result.Membros.Last.Filhos.Last.Filhos.Last.Sexo    := 'Male';
end;

function Mock_Biblioteca: TBiblioteca;
begin
  Result := TBiblioteca.Create;

  Result.Livros.Add(TLivro.Create);
  Result.Livros.Last.Nome   := 'Dom Quixote';
  Result.Livros.Last.Autor  := 'Miguel Cercantes';
  Result.Livros.Last.Edicao :=  1;
  SetLength(Result.Livros.Last.Genero, 2);
  Result.Livros.Last.Genero[1] := 'Aventura';
  Result.Livros.Last.Genero[0] := 'Fantasia';


  Result.Livros.Add(TLivro.Create);
  Result.Livros.Last.Nome   := 'Divina Comédia';
  Result.Livros.Last.Autor  := 'Dante Alighieri';
  Result.Livros.Last.Edicao := 1;
  SetLength(Result.Livros.Last.Genero, 2);
  Result.Livros.Last.Genero[0] := 'Aventura';
  Result.Livros.Last.Genero[1] := 'Fantasia';

  Result.Livros.Add(TLivro.Create);
  Result.Livros.Last.Nome   := 'Outro Livro';
  Result.Livros.Last.Autor  := 'Outro autor';
  Result.Livros.Last.Edicao :=  100;

end;

function Mock_Escola: TEscola;
begin
  Result := TEscola.Create;

  Result.Alunos.Add(TAluno.Create);
  Result.Alunos.Last.Nome := 'Eu';
  SetLength(Result.Alunos.Last.Notas, 4);
  Result.Alunos.Last.Notas[0] := 10;
  Result.Alunos.Last.Notas[1] := 20;
  Result.Alunos.Last.Notas[2] := 30;
  Result.Alunos.Last.Notas[3] := 40;

  Result.Alunos.Add(TAluno.Create);
  Result.Alunos.Last.Nome := 'Você';
  SetLength(Result.Alunos.Last.Notas, 4);
  Result.Alunos.Last.Notas[0] := 6;
  Result.Alunos.Last.Notas[1] := 12;
  Result.Alunos.Last.Notas[2] := 24;
  Result.Alunos.Last.Notas[3] := 36;

  Result.Alunos.Add(TAluno.Create);
  Result.Alunos.Last.Nome := 'Ele';
end;

function Mock_Empresa: TEmpresa;
begin
  Result := TEmpresa.Create;
  Result.Nome := 'Softeware House S/A';

  Result.Departamentos.Add(TDepartamento.Create);
  Result.Departamentos.Last.Nome := 'Gerência';
  Result.Departamentos.Last.Area := 'TI';

  Result.Departamentos.Add(TDepartamento.Create);
  Result.Departamentos.Last.Nome := 'Desenvolvimento';
  Result.Departamentos.Last.Area := 'TI';

  Result.Departamentos.Add(TDepartamento.Create);
  Result.Departamentos.Last.Nome := 'Infraestrutura';
  Result.Departamentos.Last.Area := 'TI';
end;

function Mock_Garagem: TGaragem;
begin
  Result := TGaragem.Create;
  Result.Carro.Ocupantes.Add(TPessoa.Create);
  Result.Carro.Ocupantes.Last.Nome := 'Eu';
  Result.Carro.Ocupantes.Last.Sexo := 'M';
  Result.Carro.Ocupantes.Last.Codigo := 2;

  Result.Carro.Ocupantes.Add(TPessoa.Create);
  Result.Carro.Ocupantes.Last.Nome := 'Você';
  Result.Carro.Ocupantes.Last.Sexo := 'F';
  Result.Carro.Ocupantes.Last.Codigo := 3;
end;

function Mock_Pessoas: TPessoas;
begin
  Result := TObjectList<TPessoa>.Create;
  Result.Add(TPessoa.Create);
  Result.Last.Nome    := 'Eu';
  Result.Last.Codigo  := 10;
  Result.Last.Sexo    := 'M';

  Result.Add(TPessoa.Create);
  Result.Last.Nome    := 'Você';
  Result.Last.Codigo  := 20;
  Result.Last.Sexo    := 'F';
end;

function Mock_Musica: TMusica;
begin
  Result := TMusica.Create;
  Result.Nome := 'Simple Man';
  Result.Artista := 'Lynyrd Skynyrd';
  Result.Tempo := '00:06:00';
end;

function Mock_Todos: TTodos;
begin
  Result := TTodos.Create;

  Result.Empresa.Free;
  REsult.Familia.Free;
  Result.Biblioteca.Free;
  Result.Garagem.Free;
  Result.Escola.Free;
  Result.Pessoas.Free;

  Result.Empresa    := Mock_Empresa;
  REsult.Familia    := Mock_Familia;
  Result.Biblioteca := Mock_Biblioteca;
  Result.Garagem    := Mock_Garagem;
  Result.Escola     := Mock_Escola;
  Result.Pessoas    := Mock_Pessoas;
end;
{ TBody }

constructor TFamilia.Create;
begin
  FMembros := TObjectList<TPessoa>.Create;
end;

destructor TFamilia.Destroy;
begin
  FreeAndNil(FMembros);
  inherited;
end;

{ TPessoa }

constructor TPessoa.Create;
begin
  FFilhos := TObjectList<TPessoa>.Create;
end;

destructor TPessoa.Destroy;
begin
  FreeAndNil(FFilhos);
  inherited;
end;

{ TBiblioteca }

constructor TBiblioteca.Create;
begin
  FLivros := TObjectList<TLivro>.Create;
end;

destructor TBiblioteca.Destroy;
begin
  FreeAndNil(FLivros);
  inherited;
end;

{ TDepartamento }

constructor TDepartamento.Create;
begin

end;

destructor TDepartamento.Destroy;
begin

  inherited;
end;

{ TEmpresa }

constructor TEmpresa.Create;
begin
  FDepartamentos := TObjectList<TDepartamento>.Create;
end;

destructor TEmpresa.Destroy;
begin
  FreeAndNil(FDepartamentos);
  inherited;
end;

{ TCarro }

constructor TCarro.Create;
begin
  FOcupantes :=  TObjectList<TPessoa>.Create;
end;

destructor TCarro.Destroy;
begin
  FreeAndNil(FOcupantes);
  inherited;
end;

{ TGaragem }

constructor TGaragem.Create;
begin
  FCarro := TCarro.Create;
end;

destructor TGaragem.Destroy;
begin
  FreeAndNil(FCarro);
  inherited;
end;

{ TEscola }

constructor TEscola.Create;
begin
  FAlunos := TObjectList<TAluno>.Create;
end;

destructor TEscola.Destroy;
begin
  FreeAndNil(FAlunos);
  inherited;
end;

{ TTodos }

constructor TTodos.Create;
begin
  FEscola := TEscola.Create;
  FPessoas := TPessoas.Create;
  FGaragem := TGaragem.Create;
  FEmpresa := TEmpresa.Create;
  FBiblioteca := TBiblioteca.Create;
  FFamilia := TFamilia.Create;
end;

destructor TTodos.Destroy;
begin
  FreeAndNil(FEscola);
  FreeAndNil(FPessoas);
  FreeAndNil(FGaragem);
  FreeAndNil(FEmpresa);
  FreeAndNil(FBiblioteca);
  FreeAndNil(FFamilia);

  inherited;
end;

{ TMusica }

function TMusica.GetAlbum: string;
begin
  Result := FAlbum;
end;

function TMusica.GetArtista: string;
begin
  Result := FArtista;
end;

function TMusica.GetNome: string;
begin
  Result := FNome;
end;

function TMusica.GetTempo: string;
begin
  Result := TimeToStr(StrToTime(FTempo));
end;

procedure TMusica.SetAlbum(const Value: string);
const C_NOME_MIN = 4; C_NOME_MAX = 120;
begin
  if Value <> ''
  then begin
    if Value.Length < C_NOME_MIN
    then Raise Exception.Create(Format(
      'O Nome do Álbum deverá ter no mínimo %d caracteres',
      [ C_NOME_MIN ]
    ));

    if Value.Length > C_NOME_MAX
    then Raise Exception.Create(Format(
      'O Nome do Álbum deverá ter no máximo %d caracteres',
      [ C_NOME_MAX ]
    ));
  end;

  FAlbum := Value;
end;

procedure TMusica.SetArtista(const Value: string);
const C_NOME_MIN = 4; C_NOME_MAX = 120;
begin
  if Value.Length < C_NOME_MIN
  then Raise Exception.Create(Format(
    'O Nome do Artista deverá ter no mínimo %d caracteres',
    [ C_NOME_MIN ]
  ));

  if Value.Length > C_NOME_MAX
  then Raise Exception.Create(Format(
    'O Nome do Artista deverá ter no máximo %d caracteres',
    [ C_NOME_MAX ]
  ));

  FArtista := Value;
end;

procedure TMusica.SetNome(const Value: string);
const C_NOME_MIN = 4; C_NOME_MAX = 120;
begin
  if Value.Length < C_NOME_MIN
  then Raise Exception.Create(Format(
    'O Nome da música deverá ter no mínimo %d caracteres',
    [ C_NOME_MIN ]
  ));

  if Value.Length > C_NOME_MAX
  then Raise Exception.Create(Format(
    'O Nome da música deverá ter no máximo %d caracteres',
    [ C_NOME_MAX ]
  ));

  FNome := Value;
end;

procedure TMusica.SetTempo(const Value: string);
var LTempo: TTime;
begin
  try
    LTempo := StrToTime(Value);
  except
    raise Exception.Create('O valor informado não é uma marcação de tempo válida');
  end;

  if LTempo = 0
  then raise Exception.Create('O Tempo de execução deverá ser superior a "00:00"');

  FTempo := TimeToStr(LTempo);
end;

end.

