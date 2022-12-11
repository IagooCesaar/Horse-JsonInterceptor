# Horse JsonInterceptor
> Library and Middleware to serialize Pascal ObjectList to Json without "listHelper" 

_____

Give the class:

```pascal
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
```
When try to serialize any object of this class with `REST.Json`, we obtain a json similar to this:

```pascal
uses REST.Json;

procedure SomeEvent;
var LBody: TBody; LJson : string;
begin
  LBody := TBody.Create;
  LBody.Lista := TObjectList<TPessoa>.Create;

  LBody.Lista.Add(TPessoa.Create);
  LBody.Lista.Last.Code   := 10;
  LBody.Lista.Last.Name   := 'John Doe';
  LBody.Lista.Last.Gender := 'Male';

  LBody.Lista.Add(TPessoa.Create);
  LBody.Lista.Last.Code   := 20;
  LBody.Lista.Last.Name   := 'Jane Doe';
  LBody.Lista.Last.Gender := 'Female';

  LJson := TJson.ObjectToJsonString(LBody);
end;
```

```json
{
   "lista":{
      "ownsObjects":true,
      "listHelper":[
         {
            "name":"John Doe",
            "code":10,
            "gender":"Male"
         },
         {
            "name":"Jane Doe",
            "code":20,
            "gender":"Female"
         }
      ]
   }
}
```
**Horse JsonInteceptor** takes this JSON and generates a new JSON with no unique fields for the ListHelper Delphi Object, like this:

```JSON
{
   "lista":[
      {
         "name":"John Doe",
         "code":10,
         "gender":"Male"
      },
      {
         "name":"Jane Doe",
         "code":20,
         "gender":"Female"
      }
   ]
}
```

## How to use

**Horse JsonInteceptor** can be used as library, middleware or helper, as [example](https://github.com/IagooCesaar/Horse-JsonInterceptor/blob/main/example/example%202/Controllers.pas) below:

### Library Example

```pascal
unit Controllers.LibExample;

interface

procedure Registry;

implementation

uses
  Horse,
  REST.Json,
  System.Json,

  Horse.JsonInterceptor.Core,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TBody);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Lista.Count) do
    ABody.Lista[i].Code := ABody.Lista[i].Code * 10;
end;

procedure PostWithLib(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBody;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest> // prepared by Jhonson and HorseJsonInterceptor
    .ToObject<TBody>;

  DoSomething(LBody);

  Resp.Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );
end;

procedure Registry;
begin
  THorse
    .Post('with-lib', PostWithLib)
end;

end.
```

### Middleware Example

```pascal
unit Controllers.MiddlewareExample;

interface

procedure Registry;

implementation

uses
  Horse,
  REST.Json,
  System.Json,

  Horse.JsonInterceptor,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TBody);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Lista.Count) do
    ABody.Lista[i].Code := ABody.Lista[i].Code * 10;
end;

procedure PostWithMiddleware(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBody;
begin
  LBody := TJson.JsonToObject<TBody>(
    Req.Body<TJSONObject> // prepared by Jhonson and HorseJsonInterceptor
  );

  DoSomething(LBody);

  // Can be passed as TJsonObject or String
  //Resp.Send(TJson.ObjectToJsonObject(LBody));
  Resp.Send(TJson.ObjectToJsonString(LBody));
end;

procedure Registry;
begin
  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post('with-middleware', PostWithMiddleware);
end;

end.
```

### Helper Example

```pascal
unit Controllers.HelperExample;

interface

procedure Registry;

implementation

uses
  Horse,
  Horse.JsonInterceptor.Helpers,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TBody);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Lista.Count) do
    ABody.Lista[i].Code := ABody.Lista[i].Code * 10;
end;

procedure PostWithHelper(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBody;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TBody>(Req.Body);

  DoSomething(LBody);

  Resp.Send(
    TJson.ObjectToClearJsonString(LBody)
  );
end;

procedure Registry;
begin
  THorse
    .Post('with-helper', PostWithHelper)
end;

end.
```

This will produce a result like this:
![Insomnia print with result](https://user-images.githubusercontent.com/12894025/205689609-ef1d1760-ef4a-461a-97ef-875ad7e9214d.png)


## Prerequisites
  - https://github.com/HashLoad/jhonson