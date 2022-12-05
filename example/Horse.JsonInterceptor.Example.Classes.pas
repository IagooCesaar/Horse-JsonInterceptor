unit Horse.JsonInterceptor.Example.Classes;

interface

uses System.Generics.Collections;

type TPessoa = class
  private
    FName: string;
    FCode: Integer;
    FGender: string;
  public
    property Name: string read FName write FName;
    property Code: Integer read FCode write FCode;
    property Gender: string read FGender write FGender;
end;

type TBody = class
  private
    FLista: TObjectList<TPessoa>;
  public
    property Lista: TObjectList<TPessoa> read FLista write FLista;
end;

implementation

end.
