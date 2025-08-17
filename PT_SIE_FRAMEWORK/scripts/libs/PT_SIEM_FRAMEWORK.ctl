// $License: NOLICENSE
//--------------------------------------------------------------------------------
/**
  @file $relPath
  @copyright $copyright
  @author z004u6jf
*/

//--------------------------------------------------------------------------------
// Libraries used (#uses)

//--------------------------------------------------------------------------------
// Variables and Constants


//--------------------------------------------------------------------------------
//@public members
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
//@private members
//--------------------------------------------------------------------------------
global dyn_dyn_string ddsNavibuttonsPerScreen;
global dyn_anytype daCollection; //shared_ptr<GUINaviButtonCollection>
global dyn_string tmp = makeDynString(); // temporary array

//shared_ptr<GUINaviButtonCollection> ButtonCollection = new GUINaviButtonCollection();

//ToDo: perhaps collection needs to be global?

public shared_ptr<GUINaviButtonCollection> GetGuiNaviButtonCollection()
{
  return ButtonCollection;
}


synchronized PT_SIEM_addNaviButton(string id, string parentId/*,shared_ptr<GUINaviButtonCollection> ButtonCollection*/)
{
  string moduleName = myModuleName(); /*"naviModule_1";*/ /*"_QuickTest_";*/
  string panelName = rootPanel(moduleName);/*"Navi";*//*"para/PanelTopology/templates/SIE/naviPanel_1024_768_SIE.pnl";*/
  bool bParentNode, bSubNode;
//get my screen number

  int iScreennumber = GetMyScreenNumber();//Ahmed change the screen number

  if (dynlen(ddsNavibuttonsPerScreen) < iScreennumber)
  {
    ddsNavibuttonsPerScreen[iScreennumber] = makeDynString();
  }

  if (parentId == "1")
  {
    bParentNode = true;
    bSubNode = false;
  }

  else if (parentId == "0")
  {
    bParentNode = false;
    bSubNode = false;
  }
  else
  {
    bParentNode = false;
    bSubNode = true;
  }

  int iNewLayoutRow = dynContains(ddsNavibuttonsPerScreen[iScreennumber], parentId) + 1;
//perhaps +1 s require

  //DebugTN("whenaddingthesymbol", moduleName, panelName, "navi_btn_" + id);
  addSymbol(moduleName, panelName, "objects/side_menu_buttons/generic.pnl", "navi_btn_" + id,
            iNewLayoutRow, moduleName + "." + panelName + ":" + "LAYOUT_GROUP1",
            makeDynString("$nodeId:" + id, "$bParentNode:" + bParentNode, "$bSubNode:" +bSubNode));



//row number to insert
//addSymobl



  dynInsertAt(ddsNavibuttonsPerScreen[iScreennumber], id, iNewLayoutRow);

//ButtonCollection.Clear();
  daCollection[iScreennumber].Clear();
  dyn_string shapes = getShapes(moduleName, panelName, "", true);
  dyn_string buttons;

  for (int i = 0; i < shapes.count(); i++)
  {
    if (!buttons.contains(shapes.at(i).split(".").at(0)) && shapes.at(i).split(".").at(0).contains("btn"))
    {
      buttons.append(shapes.at(i).split(".").at(0));
    }
  }

  for (int i = 0; i < buttons.count(); i++)
  {
    shape tmp = getShape(myModuleName(), myPanelName(), buttons.at(i));
    daCollection[iScreennumber].Append(tmp.GetGUINaviButton());
  }

}






PT_SIEM_removeNaviButton(string parentId,dyn_int myChildrensIndecies) synchronized(ddsNavibuttonsPerScreen)
{

  string moduleName = myModuleName(); /*"naviModule_1";*/ /*"_QuickTest_";*/
  string panelName = rootPanel(moduleName);
  int iScreennumber = GetMyScreenNumber();//Ahmed change the screen number

/*dyn_int childIndecies = GetChildIndecies(parentId);
dyn_int childIDs = GetChildIDs(parentId);
DebugTN("++++++++++++++++++++",childIndecies,childIDs);*/

 // DebugTN("childIndecies00000000000000000",childIndecies);
  //implemennt forloop for all childs

 /*for (int i = 1;i<=dynlen(childIndecies);i++)
{int vartestIndex = 3;
  int index = childIndecies[i];

 // DebugTN("found??", index);

  if (index < 1)
    return;

  daCollection[iScreennumber].RemoveByIndex(index );
  //remove from collection?
 // DebugTN("afteraddingthesymbol", moduleName, panelName, "navi_btn_" + index+1);
   // DebugTN("------------------------------",dynlen(ddsNavibuttonsPerScreen[iScreennumber]),dynlen(daCollection[iScreennumber]));
  removeSymbol(moduleName, panelName, "navi_btn_" + childIDs[i]);
  dynRemove(ddsNavibuttonsPerScreen[iScreennumber], index);

}*/

  DebugTN("my IDs for deletion are :", myChildrensIndecies);
for (int i =dynlen(myChildrensIndecies);i>=1 ;i-- )

{
int  currentElementIndex=dynContains(ddsNavibuttonsPerScreen[iScreennumber], myChildrensIndecies[i]);
  if(currentElementIndex !=0)
  {
        DebugTN("my IThe required info :", myChildrensIndecies[i],"dynContains(ddsNavibuttonsPerScreen[iScreennumber], myChildrensIndecies[i])",dynContains(ddsNavibuttonsPerScreen[iScreennumber], myChildrensIndecies[i]));
    daCollection[iScreennumber].RemoveByIndex(currentElementIndex);
    removeSymbol(moduleName, panelName, "navi_btn_" +myChildrensIndecies[i]);
    dynRemove(ddsNavibuttonsPerScreen[iScreennumber], currentElementIndex);

  }
  else
  {
    DebugTN("I am not able to find id number ",myChildrensIndecies[i], " in the layout");
  }
        DebugTN("ddsNavibuttonsPerScreen[iScreennumber]",ddsNavibuttonsPerScreen[iScreennumber]);
}


}


 dyn_int GetChildIndecies(string parentId)
 {
   int iScreennumber = GetMyScreenNumber();
 // DebugTN("currentParentIndex", currentParentIndex);
  string strServerName = getSystemName();
  dyn_uint ParentNumbers;
  dyn_int childIds;
  dyn_int childINdeciesInLayout;
  dpGet(strServerName + "_PanelTopology.parentNumber", ParentNumbers);

  for (int i = 1; i <= dynlen(ParentNumbers); i++)
  {


    if (ParentNumbers[i]== parentId)
    {

      childIds.append(i);

    }

 }
 // DebugTN("childIds",childIds);
 // DebugTN("childIds",childIds);
   for (int i = 1; i <= dynlen(childIds); i++)
  {

   // DebugTN("dynContains(dynContains(ddsNavibuttonsPerScreen[iScreennumber], childIds[i])",dynContains(ddsNavibuttonsPerScreen[iScreennumber], childIds[i]));

  if(dynContains(ddsNavibuttonsPerScreen[iScreennumber], childIds[i])!=-1)
    {
    childINdeciesInLayout.append(dynContains(ddsNavibuttonsPerScreen[iScreennumber], childIds[i]));
    //  DebugTN("childINdeciesInLayout",childINdeciesInLayout);
    }

 }

  return childINdeciesInLayout;
}

 dyn_int GetChildIDs(string parentId)
 {
   int iScreennumber = GetMyScreenNumber();
 // DebugTN("currentParentIndex", currentParentIndex);
  string strServerName = getSystemName();
  dyn_uint ParentNumbers;
  dyn_int childIds;
  dyn_int childINdeciesInLayout;
  dpGet(strServerName + "_PanelTopology.parentNumber", ParentNumbers);

  for (int i = 1; i <= dynlen(ParentNumbers); i++)
  {


    if (ParentNumbers[i]== parentId)
    {

      childIds.append(i);

    }

 }
  return childIds;

}



int GetMyScreenNumber()
{
 //DebugN("myscreen number", myModuleName());
  string moduleName = myModuleName();
  int iScreenNum =0;
   // DebugTN("moduleName.at(moduleName.length()",moduleName.at(moduleName.length()),moduleName.at(moduleName.length()-1));
   // DebugTN("at(moduleName.length()-1)",moduleName.at(moduleName.length()-1));
  iScreenNum= (int)moduleName.at(moduleName.length()-1);

//  if (iScreenNum ==0)
//   {
//     DebugTN("the moduleName does not contain screen number");
//     return -1;
//   }
//   else*/
  DebugTN("iScreenNum",iScreenNum);
    return iScreenNum;

}

bool doIhaveAChild(int myID)
{
  bool Answer = false;

  string strServerName = getSystemName();
  dyn_uint ParentNumbers;
  dpGet(strServerName + "_PanelTopology.parentNumber", ParentNumbers);

  for (int i = 1; i <= dynlen(ParentNumbers); i++)
  {
    DebugTN("i=", i);

    if (ParentNumbers[i] == myID)
    {

      Answer = true;

    }


  }

//"System1:_PanelTopology.parentNumber"

  return Answer;

}





















