unit Horse.JsonInterceptor;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  SysUtils, Classes, HTTPDefs, fpjson, jsonparser,
{$ELSE}
  System.Classes, System.JSON, System.SysUtils, Web.HTTPApp,
{$ENDIF}
  Horse, Horse.Commons,
  REST.Json,
  Horse.JsonInterceptor.Core;

function HorseJsonInterceptor: THorseCallback; overload;

implementation

function HorseJsonInterceptor: THorseCallback; overload;
begin
  result :=
    procedure(
      ARequest: THorseRequest;
      AResponse: THorseResponse;
      ANext: TProc)
    var LBody: String; LOrignalJson, LModifiedJson : TJSONValueFPCDelphi;
    begin
      LBody := ARequest.Body;
      if  ARequest.RawWebRequest.ContentType.Contains('application/json')
      and (Trim(LBody) <> '') then
      begin
        try
          LOrignalJson := {$IF DEFINED(FPC)} GetJSON(LBody) {$ELSE}TJSONObject.ParseJSONValue(LBody){$ENDIF};
        except
          AResponse.Send('Invalid JSON').Status(THTTPStatus.BadRequest);
          raise EHorseCallbackInterrupted.Create;
        end;

        if not Assigned(LOrignalJson) then
        begin
          AResponse.Send('Invalid JSON').Status(THTTPStatus.BadRequest);
          raise EHorseCallbackInterrupted.Create;
        end;

        LOrignalJson := THorseJsonInterceptor.CriarListHelperArray(LOrignalJson);

        ARequest.Body(LOrignalJson);
      end;

      try
        ANext();
      finally
        if  (AResponse.Content <> nil)
        and AResponse.Content.InheritsFrom(TJSONValueFPCDelphi)
        then begin
          LOrignalJson := TJSONValueFPCDelphi(AResponse.Content);
          LModifiedJson := THorseJsonInterceptor.RemoverListHelperArray(LOrignalJson);
          AResponse.Send(LModifiedJson);

          {$IF DEFINED(FPC)}
          AResponse.RawWebResponse.ContentStream :=
            TStringStream.Create(TJsonData(LModifiedJson).AsJSON);
          {$ELSE}
          AResponse.RawWebResponse.Content :=
            {$IF CompilerVersion > 27.0}
              TJSONValue(LModifiedJson).ToJSON
            {$ELSE}
              TJSONValue(LModifiedJson).ToString
            {$ENDIF};
          {$ENDIF}
        end else begin
          LBody := AResponse.RawWebResponse.Content;
          try
            LModifiedJson := {$IF DEFINED(FPC)} GetJSON(LBody) {$ELSE}TJSONObject.ParseJSONValue(LBody){$ENDIF};

            if Assigned(LModifiedJson) then begin
              LModifiedJson := THorseJsonInterceptor.RemoverListHelperArray(LModifiedJson);
              AResponse.Send(LModifiedJson);
            end;
          except
            // do nothing
          end;
        end;
      end;
    end;
end;

end.

