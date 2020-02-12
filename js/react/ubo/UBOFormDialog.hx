package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import mui.core.typography.TypographyVariant;
import mui.icon.Close;
import react.mui.Box;
import react.ubo.UBOForm;
import react.ubo.vo.UboVO;

private typedef Props = {
    declarationId: Int,
    open: Bool,
    canEdit: Bool,
    ?ubo: UboVO,
    onClose: (refresh: Bool) -> Void,
};

private typedef PrivateProps = {
    >Props,
    uboIsSubmitting: Bool,
};

@:publicProps(Props)
@:wrap(Provider.withUBOContext)
class UBOFormDialog extends ReactComponentOfProps<PrivateProps> {

    public function new(props: PrivateProps) {
        super(props);
    }

    override public function render() {
        var res = 
            <Dialog open={props.open} onClose=$close>
                {renderDialogTitle()}
                <DialogContent>
                    <UBOForm
                        declarationId={props.declarationId}
                        ubo={props.ubo}
                        canEdit={props.canEdit}
                        />
                </DialogContent>
                {renderSubmitingProgress()}
            </Dialog>
        ;

        return jsx('$res');
    }

    private function renderDialogTitle() {
        return 
            <DialogTitle>
                <Box display="flex" justifyContent="space-between" alignItems="center">
                    <Box>
                        <Typography variant={TypographyVariant.H5}>Bénéficiaire effectif (UBO)</Typography>
                    </Box>
                    <IconButton disabled={props.uboIsSubmitting} onClick=$close>
                        <Close />
                    </IconButton>
                </Box>
            </DialogTitle>
        ;
    }

    private function renderSubmitingProgress() {
        if (props.uboIsSubmitting) return <LinearProgress />;
        return <></>;
    }

    private function close() {
        if (!props.uboIsSubmitting) {
            props.onClose(false);
        }
    }
}