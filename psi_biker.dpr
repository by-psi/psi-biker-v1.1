program psi_biker;

uses
  System.StartUpCopy,
  FMX.Forms,
  md_principal in 'md_principal.pas' {F_principal};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TF_principal, F_principal);
  Application.Run;
end.
