declare module 'pingpong/elm' {
  type ElmApp = {
    ports: {
      [portName: string]: {
        subscribe: (value: any) => void;
        unsubscribe: () => void;
        send: (value: any) => void;
      };
    };
  };

  export const Main: {
    embed(node: HTMLElement | null): ElmApp;
  };
}
