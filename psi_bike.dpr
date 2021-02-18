program psi_bike;

uses
  System.StartUpCopy,
  FMX.Forms,
  md_principal in 'md_principal.pas' {F_principal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF_principal, F_principal);
  Application.Run;
end.
