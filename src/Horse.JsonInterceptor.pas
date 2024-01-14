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
    var LBody: String; LOriginalReq, LModifiedReq, LOriginalResp, LModifiedResp : TJSONValueFPCDelphi;
    begin
      LBody := ARequest.Body;
      if  ARequest.RawWebRequest.ContentType.Contains('application/json')
      and (Trim(LBody) <> '') then
      begin
        var bTraduzir: Boolean:= True;

        try
          LOriginalReq := {$IF DEFINED(FPC)} GetJSON(LBody) {$ELSE}TJSONObject.ParseJSONValue(LBody){$ENDIF};
        except
          bTraduzir:= False;
        end;

        if (bTraduzir) and (not Assigned(LOriginalReq)) then
          bTraduzir:= False;

        if bTraduzir then
        begin
          try
            LModifiedReq := THorseJsonInterceptor.CriarListHelperArray(LOriginalReq);

            if   ARequest.Body<TObject> <> nil
            then ARequest.Body<TObject>.Free;

            ARequest.Body(LModifiedReq);
            LOriginalReq.Free;
          except
            AResponse.Send('Invalid JSON').Status(THTTPStatus.BadRequest);
            raise EHorseCallbackInterrupted.Create;
          end;
        end;
      end;

      try
        ANext();
      finally
        if  (AResponse.Content <> nil)
        and AResponse.Content.InheritsFrom(TJSONValueFPCDelphi)
        then begin
          LOriginalResp := TJSONValueFPCDelphi(AResponse.Content);
          LModifiedResp := THorseJsonInterceptor.RemoverListHelperArray(LOriginalResp);
          AResponse.Send(LModifiedResp);

          {$IF DEFINED(FPC)}
          AResponse.RawWebResponse.ContentStream :=
            TStringStream.Create(TJsonData(LModLModifiedRespifiedJson).AsJSON);
          {$ELSE}
          AResponse.RawWebResponse.Content :=
            {$IF CompilerVersion > 27.0}
              TJSONValue(LModifiedResp).ToJSON
            {$ELSE}
              TJSONValue(LModifiedResp).ToString
            {$ENDIF};
          {$ENDIF}
        end else begin
          LBody := AResponse.RawWebResponse.Content;
          try
            LOriginalResp := {$IF DEFINED(FPC)} GetJSON(LBody) {$ELSE}TJSONObject.ParseJSONValue(LBody){$ENDIF};

            if Assigned(LOriginalResp) then begin
              LModifiedResp := THorseJsonInterceptor.RemoverListHelperArray(LOriginalResp);
              AResponse.Send(LModifiedResp.Clone as TJSONValueFPCDelphi);

              LOriginalResp.Free;
              LModifiedResp.Free;
            end;
          except
            // do nothing
          end;
        end;
      end;
    end;
end;

end.

