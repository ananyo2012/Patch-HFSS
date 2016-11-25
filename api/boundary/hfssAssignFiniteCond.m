function hfssAssignFiniteCond(fid, Name, BoxObject, material, thickness, igp)

fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup")\n');
fprintf(fid, 'oModule.AssignFiniteCond Array("NAME:%s", "Objects:=", Array( _\n',Name);
fprintf(fid, '  "%s"), "UseMaterial:=", true, "Material:=", "%s", "Roughness:=",  _\n', BoxObject, material);
fprintf(fid, '  "0um", "UseThickness:=", true, "Thickness:=", "%s", "InfGroundPlane:=",  _\n', thickness);
if(igp)
    fprintf(fid, '  true)\n\n'); 
else
    fprintf(fid, '  false)\n\n'); 
end
% hfssAssignFiniteCond(fid,'Pad43', 0,'um', {'Pad43'});