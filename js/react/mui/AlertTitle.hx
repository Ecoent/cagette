package react.mui;

import react.ReactComponent;
import react.ReactNode;

typedef AlertTitleProps = {
    children: ReactNode,
};

@:jsRequire('@material-ui/lab', 'AlertTitle')
extern class AlertTitle extends react.ReactComponentOfProps<AlertTitleProps> {}

