import Node from "@geppettoengine/geppetto-client/js/components/interface/flexLayout2/src/model/Node";

/*
 * status can be one of:
 *  - ACTIVE: the user can see the tab content.
 *  - MINIMIZED: the tab is minimized.
 *  - HIDDEN:  other tab in the node is currently selected
 *  - MAXIMIZED:  the tab is maximized (only one tab can be maximized simultaneously)
 */
export enum WidgetStatus {
  HIDDEN = "HIDDEN",
  ACTIVE = "ACTIVE",
  MAXIMIZED = "MAXIMIZED",
  MINIMIZED = "MINIMIZED",
}

export enum TabsetPosition {
  LEFT = "LEFT",
  RIGHT = "RIGHT",
  TOP = "TOP",
  BOTTOM = "BOTTOM"
}

export interface ExtendedNode extends Node {
  config: Widget;
}

export interface Widget {
  id: string;
  status: WidgetStatus;
  panelName: string;
  defaultPanel?: any;
  defaultPosition?: TabsetPosition;
  defaultWeight?: number;
  hideOnClose?: boolean;
  name: string;
  enableClose?: boolean;
  component: string;
  enableDrag?: boolean;
  enableRename?: boolean;
  pos?: number;
}

export interface WidgetComponent {
  exportSession: () => any;
  importSession: (any) => void;
}