unit Horse.JsonInterceptor.Helpers;

interface

uses
  System.Json,
  REST.Json;

type
  TJsonOption = REST.Json.TJsonOption;
  TJsonOptions = REST.Json.TJsonOptions;
  TJsonValidationRule = ( joRevalidateSetters );
  TJsonValidationRules = set of TJsonValidationRule;
  TJson = REST.Json.TJson;

  THorseJsonInterceptorHelperRestJson = class helper for Rest.Json.TJson
  public
    const CDefaultValidations = [];

    class function ObjectToClearJsonValue(AObject: TObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations
    ): TJSONValue;

    class function ObjectToClearJsonObject(AObject: TObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations
    ): TJSONObject;

    class function ObjectToClearJsonString(AObject: TObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations
    ): string;


    class function ClearJsonAndConvertToObject<T: class, constructor>(AJsonObject: TJSONObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations): T; overload;

    class function ClearJsonAndConvertToObject<T: class, constructor>(const AJson: string;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations): T; overload;

    class function ClearJsonAndConvertToObject<T: class, constructor>(AJsonValue: TJSONValue;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations): T; overload;

    class function RevalidateSetters<T: class, constructor>(const AObject: T): T; overload;
    class function RevalidateSetters<T: class, constructor>(const AJsonObject: TJsonObject): T; overload;
    class function RevalidateSetters<T: class, constructor>(const AJsonValue: TJsonValue): T; overload;
  end;

implementation

uses
  Horse.JsonInterceptor.Core;

{ TBDMGHorseToolsHelperRestJson }

class function THorseJsonInterceptorHelperRestJson.ClearJsonAndConvertToObject<T>(
  AJsonObject: TJSONObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): T;
begin
  Result := ClearJsonAndConvertToObject<T>(AJsonObject.ToString,
    AOptions, AValidations);
end;

class function THorseJsonInterceptorHelperRestJson.ClearJsonAndConvertToObject<T>(
  AJsonValue: TJSONValue; AOptions: TJsonOptions; AValidations: TJsonValidationRules): T;
var LJsonModified: TJSONObject;
begin
  Result := ClearJsonAndConvertToObject<T>(AJsonValue.ToString,
    AOptions, AValidations);
end;

class function THorseJsonInterceptorHelperRestJson.ClearJsonAndConvertToObject<T>(
  const AJson: string; AOptions: TJsonOptions; AValidations: TJsonValidationRules): T;
var LClearJson: String;
begin
  LClearJson := THorseJsonInterceptor.CriarListHelperArray(AJson);

  Result := Self.JsonToObject<T>(LClearJson, AOptions);

  if joRevalidateSetters in AValidations
  then begin
    var LObj := Result;
    try
      Result := RevalidateSetters<T>(LObj);
    finally
      LObj.Free;
    end;
  end;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonValue(
  AObject: TObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): TJSONValue;
var LJson: TJSONObject;
begin
  LJson := Self.ObjectToJsonObject(AObject, AOptions);
  try
    Result := THorseJsonInterceptor.RemoverListHelperArray(
      LJson as TJsonValue);
  finally
    LJson.DisposeOf;
  end;
end;

class function THorseJsonInterceptorHelperRestJson.RevalidateSetters<T>(const AJsonValue: TJsonValue): T;
begin
  Result := ClearJsonAndConvertToObject<T>(AJsonValue.ToString, [joSerialAllPubProps]);
end;

class function THorseJsonInterceptorHelperRestJson.RevalidateSetters<T>(const AJsonObject: TJsonObject): T;
begin
  Result := ClearJsonAndConvertToObject<T>(AJsonObject, [joSerialAllPubProps]);
end;

class function THorseJsonInterceptorHelperRestJson.RevalidateSetters<T>(const AObject: T): T;
var LJson: TJSONValue;
begin
  LJson := ObjectToClearJsonValue(AObject);
  try
    Result := RevalidateSetters<T>(LJson);
  finally
    LJson.Free;
  end;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonObject(
  AObject: TObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): TJSONObject;
begin
  Result := ObjectToClearJsonValue(AObject, AOptions) as TJSONObject;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonString(
  AObject: TObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): string;
begin
  Result := Self.ObjectToJsonString(AObject, AOptions);

  Result := THorseJsonInterceptor.RemoverListHelperArray(Result);
end;

end.
