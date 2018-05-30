public class UISyphonControls extends UICollapsibleSection {
  public UISyphonControls(final LXStudio.UI ui) {
    super(ui, 0, 0, ui.leftPane.global.getContentWidth(), 200);
    setTitle("Select Syphon Server");

    List<OutputItem> items = new ArrayList<OutputItem>();
    //items.add(new OutputItem());

    //println(SyphonClient.listServers());
    HashMap<String, String>[] allServers = SyphonClient.listServers();

    for (int i = 0; i < allServers.length; i++) {

      String appName = allServers[i].get("AppName");
      String serverName = allServers[i].get("ServerName");

      items.add(new OutputItem(appName, serverName));
    }
    UIItemList.ScrollList list =  new UIItemList.ScrollList(ui, 0, 0, getContentWidth(), getContentHeight());
    list.setSingleClickActivate(true);
    //list.setMomentary(true);
    //list.setReorderable(true);
    //list.setShowCheckboxes(true);
    list.setItems(items);
    list.addToContainer(this);
    
  }

  class OutputItem extends UIItemList.Item {
    String appName;
    String serverName;
    Boolean active = false;
    Boolean checked = false;

    OutputItem(String appName, String serverName) {
      this.appName = appName;
      this.serverName = serverName;
    }

    public boolean isActive() {
      return active;
    }

    public int getActiveColor(UI ui) {
      return ui.theme.getAttentionColor();
    }

    public boolean isChecked() {
      return checked;
    }

    public void onActivate() {
      active = !active;
      redraw();
    }

    public void onCheck(boolean checked) {
      this.checked = checked;
    }

    public String getLabel() {
      //return "Test";
      return String.format("%s, %s", this.appName, this.serverName);
      //return String.format("%s / %d-%d", this.datagram.getAddress().getHostAddress(), this.datagram.getChannel(), this.datagram.getChannel()+3);
    }
  }
}
