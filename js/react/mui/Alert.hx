package react.mui;

import react.ReactComponent;
import react.ReactNode;

typedef AlertProps = {
    severity: String,
    children: ReactNode,
    ?className: String,
};

@:jsRequire('@material-ui/lab', 'Alert')
extern class Alert extends react.ReactComponentOfProps<AlertProps> {}

