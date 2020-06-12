import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';

class ListaInspeccionPage extends StatefulWidget {
  @override
  _ListaInspeccionPageState createState() => _ListaInspeccionPageState();
}

class _ListaInspeccionPageState extends State<ListaInspeccionPage> {
  @override
  Widget build(BuildContext context) {

    final _inspeccionBloc = Provider.inspeccionBloc(context);

    return Stack(
      children: <Widget>[
        _fondoApp(),
        SafeArea(
          child: StreamBuilder(
            stream: _inspeccionBloc.inspeccionesStream,
            builder: ( context, AsyncSnapshot<List<InspeccionModel>> snapshot) {

              if ( !snapshot.hasData ){

                return Text('No hay datos');

              } else {

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: ( context, index)  => Dismissible(
                    key: UniqueKey(),
                    background: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.delete),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 200.0,
                              spreadRadius: 0.5,
                              offset: Offset(-8.0, 10.0)
                            )
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.6),
                              Colors.grey
                            ]
                          ),
                        ),
                      ),
                    ),
                    onDismissed: ( direction ) => { _inspeccionBloc.eliminarInspeccion( snapshot.data[index] ) },
                    child: _tarjeta(context, _inspeccionBloc, snapshot.data[index]),
                  ),
                );

              } 
            }
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                FloatingActionButton.extended(
                  onPressed: (){
                    _mostrarAlertaInspector(context, _inspeccionBloc);
                    // crear informe con las deficiencias
                  },
                  label: Text('Crear Inspector'),
                ),
                SizedBox(width: 10.0,),
                FloatingActionButton.extended(
                  onPressed: (){
                    _mostrarAlertaInspeccion(context, _inspeccionBloc);
                    // crear informe con las deficiencias
                  },
                  label: Text('Crear Inspeccion'),
                ),
              ],
              
            ),
          ),
        )
      ],
    );
  }

  Widget _fondoApp() {

    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0)
          ],
        )
      ),
    );

    final cajaRosa = Transform.rotate(
      angle: -pi / 5.2,
      child: Container(
        height: 350.0,
        width: 350.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(85.0),
          gradient: LinearGradient(
            colors: [
              Colors.cyanAccent,
              Colors.blueAccent
            ]
          ),
        ),
      ),
    );
    

    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(
          top: -100,
          child: cajaRosa
        ),
      ],
    );
  }

  Widget _tarjeta( BuildContext context, InspeccionBloc bloc, InspeccionModel inspeccion ) {

// si quiero quitar el boton de evaluar pongo un gesture detector aqui y quito el boton
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(-8.0, 10.0)
          )
        ],
      ),
      child: Card(
        elevation: 20.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
              _texto(inspeccion),
              _botonEvaluar(context, bloc, inspeccion)
          ],
        ),
      ),
    );

  }

  Widget _texto( InspeccionModel inspeccion ) {

    return Container(
      width: 160,
      child: Text(
        inspeccion.lugar,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
      ),
    );

  }

  Widget _botonEvaluar( BuildContext context, InspeccionBloc bloc, InspeccionModel inspeccion) {

    return Container(
      padding: EdgeInsets.all(10.0),
      child: FloatingActionButton.extended(
        heroTag: UniqueKey(),
        backgroundColor: Color.fromRGBO(52, 54, 101, 1.0),
        onPressed: (){
          Navigator.pushNamed(context, 'categorias', arguments: inspeccion);
        },
        label: Text('Inspeccionar', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.white),),
        icon: Icon(Icons.search, color: Colors.blueAccent),
      ),
    );

  }

  void _mostrarAlertaInspector( BuildContext context, InspeccionBloc bloc) {

    final size = MediaQuery.of(context).size;

    final inspector = Inspector();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 35.0),
            child: Container(
              width: size.width * 0.80,
              // margin: EdgeInsets.symmetric(vertical: 30.0),
              // padding: EdgeInsets.symmetric(vertical: 40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  Container( 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple,
                          Colors.blue
                        ]
                      ),
                    ),
                    alignment: Alignment.center,
                    height: size.height * 0.1,
                    width: double.infinity,
                    child: Text('Crear Inspector', style: TextStyle(decoration: TextDecoration.none, fontSize: 20.0, color: Colors.white) ,),
                  ),
                  Material(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            _crearTextNombre(inspector),
                            _crearTextDNI(inspector),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          bloc.agregarInspector(inspector);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
        );
      }
    );

  }


  void _mostrarAlertaInspeccion( BuildContext context, InspeccionBloc bloc) {

    final size = MediaQuery.of(context).size;
    
    final inspeccion = InspeccionModel();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 35.0),
          child: Container(
            width: size.width * 0.80,
            // margin: EdgeInsets.symmetric(vertical: 30.0),
            // padding: EdgeInsets.symmetric(vertical: 40.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Container( 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.blue
                      ]
                    ),
                  ),
                  alignment: Alignment.center,
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Text('Crear Inspección', style: TextStyle(decoration: TextDecoration.none, fontSize: 20.0, color: Colors.white) ,),
                ),
                Material(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          _crearTextFieldLugar(inspeccion),
                          _crearTextFieldComentarios(inspeccion),
                          _crearSeleccionInspector(inspeccion, bloc),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        bloc.agregarInspeccion(inspeccion);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        );
      }
    );

  }

  Widget _crearTextNombre( Inspector inspector) {

    return TextFormField(
      initialValue: inspector.nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => setState(() {
          inspector.nombre = value;
      }),
      validator: (value) {
        if ( value.length < 2 ) {
          return 'Ingrese más de 2 carácteres';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearTextDNI( Inspector inspector) {

    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      initialValue: inspector.dni,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'DNI',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => setState(() {
          inspector.dni = value;
      }),
      validator: (value) {
        if ( value.length < 2 ) {
          return 'Ingrese más de 2 carácteres';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearTextFieldLugar( InspeccionModel inspeccion ) {

    return TextFormField(
      initialValue: inspeccion.lugar,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Lugar',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => inspeccion.lugar = value,
      validator: (value) {
        if ( value.length < 3 ) {
          return 'Ingrese el lugar donde se va a realizar la inspección';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearTextFieldComentarios( InspeccionModel inspeccion ) {

    return TextFormField(
      maxLines: 3,
      initialValue: inspeccion.comentarios,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Comentarios',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onChanged: (value) => inspeccion.comentarios = value,
      validator: (value) {
        if ( value.length < 3 ) {
          return 'Ingrese un comentario';
        } else {
          return null;
        }
      },
    );

  }

  Widget _crearSeleccionInspector( InspeccionModel inspeccion, InspeccionBloc bloc ) {

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Selección Inspector',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      value: inspeccion.inspector,
      onChanged: ( value ) => setState(() {
          inspeccion.inspector = value;
      }),
      items: bloc.inspectores
        .map<DropdownMenuItem<Inspector>>((Inspector value) {
      return DropdownMenuItem<Inspector>(
        value: value,
        child: (value.nombre) == null ? Text('') : Text(value.nombre),
      );
      }).toList(),
    );

  }
}