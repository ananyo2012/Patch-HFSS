function hfssAssignInfinityPE(fid,name)
fprintf(fid, 'Set oModule = oDesign.GetModule("BoundarySetup") \n');
fprintf(fid, 'oModule.DeleteBoundaries Array("%s") \n',name);
fprintf(fid, 'oModule.AssignPerfectE Array("NAME:%s", "Objects:=", Array("Ground"), "InfGroundPlane:=",true) \n',name);
fprintf(fid, ' \n');

end






