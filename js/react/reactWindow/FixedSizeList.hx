package react.reactWindow;

import react.ReactComponent;
import react.ReactNode;

typedef FixedSizeListProps = {
    height: Int,
    width: Int,
    itemSize: Int,
    itemCount: Int,
    children: Dynamic,
};

@:jsRequire('react-window', 'FixedSizeList')
extern class FixedSizeList extends react.ReactComponentOfProps<FixedSizeListProps> {}