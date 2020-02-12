package react.common;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import mui.core.typography.TypographyVariant;
import mui.icon.Close;
import react.mui.Box;

private typedef Props = {
    open: Bool,
    title: String,
    children: ReactNode,
    onClose: () -> Void,
    ?loading: Bool,
};

class FormDialog extends ReactComponentOfProps<Props> {

    public function new(props: Props) {
        super(props);
    }

    override public function render() {
        var progress = props.loading != null && props.loading ? <LinearProgress /> : <></>;

        var res = 
            <Dialog open={props.open} onClose=${props.onClose}>
                <DialogTitle>
                    <Box display="flex" justifyContent="space-between" alignItems="center">
                        <Box>
                            <Typography variant={TypographyVariant.H5}>{props.title}</Typography>
                        </Box>
                        <IconButton disabled={props.loading} onClick=${props.onClose}>
                            <Close />
                        </IconButton>
                    </Box>
                </DialogTitle>
                <DialogContent>
                    {props.children}
                </DialogContent>
                {progress}
            </Dialog>
        ;

        return jsx('$res');
    }
}