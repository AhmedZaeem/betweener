import 'package:betweener/Controllers/LinksHelper.dart';
import 'package:betweener/Models/Link.dart';
import 'package:betweener/Widgets/MyTextFormField.dart';
import 'package:betweener/Widgets/My_Button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLink extends StatefulWidget {
  final Link? linkToEdit;
  const AddLink({super.key, this.linkToEdit});

  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  late TextEditingController _usernameController;
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  final _key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.linkToEdit == null) {
      _usernameController = TextEditingController();
      _titleController = TextEditingController();
      _linkController = TextEditingController();
    } else {
      _usernameController =
          TextEditingController(text: widget.linkToEdit!.username);
      _titleController = TextEditingController(text: widget.linkToEdit!.title);
      _linkController = TextEditingController(text: widget.linkToEdit!.link);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _titleController.dispose();
    _linkController.dispose();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 44.w),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  MyTextFormField(
                    textFieldLabel: 'Username',
                    hint: 'BeautifulUsername',
                    controller: _usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a valid username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  MyTextFormField(
                    textFieldLabel: 'Title',
                    hint: 'Instagram',
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter a valid title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  MyTextFormField(
                    textFieldLabel: 'Link',
                    hint: 'https:\\\\www.instagram.com',
                    controller: _linkController,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('.')) {
                        return 'please enter a valid link';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 52.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.w),
                    child: My_Button(
                      buttonText: widget.linkToEdit == null ? 'ADD' : 'EDIT',
                      textColor: Colors.black,
                      onTap: widget.linkToEdit == null
                          ? preformAddLink
                          : preformEditLink,
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading
              ? PositionedDirectional(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(.4),
                  ),
                )
              : const SizedBox.shrink(),
          loading
              ? const PositionedDirectional(
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  preformAddLink() async {
    if (_key.currentState!.validate()) {
      setState(() => loading = true);
      var x = await addLinks({
        'title': _titleController.text,
        'link': _linkController.text,
        'username': _usernameController.text,
      });
      setState(() => loading = false);
      if (x && mounted) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          backgroundColor: Colors.white,
          title: 'Success',
          text: 'Link was added successfully!',
        ).then((value) => Navigator.pop(context, true));
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          backgroundColor: Colors.white,
          title: 'Failed',
          text: 'Something went wrong',
        );
      }
    }
  }

  preformEditLink() async {
    if (_key.currentState!.validate()) {
      setState(() => loading = true);
      await editLink({
        'username': _usernameController.text,
        'title': _titleController.text,
        'link': _linkController.text,
      }, widget.linkToEdit!.id!)
          .then((value) async {
        if (true) {
          await CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: 'Success',
            text: 'Link edited successfully',
            backgroundColor: Colors.green,
          ).then((value) {
            Navigator.pop(context, true);
          });
          setState(() => loading = false);
        } else {
          setState(() => loading = false);
          await CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: 'An error has occurred',
            text: 'something went wrong please try again',
            backgroundColor: Colors.red,
          );
        }
      });
    }
  }
}
